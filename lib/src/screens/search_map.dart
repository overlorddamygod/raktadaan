// import 'dart:html';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'package:geolocator/geolocator.dart';
// import 'package:geolocator_web/geolocator_web.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import 'package:latlong2/latlong.dart';
import 'package:raktadaan/src/models/user_model.dart';
import 'package:raktadaan/src/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SearchMapScreen extends StatefulWidget {
  const SearchMapScreen({super.key});
  static const routeName = '/settings';

  @override
  State<SearchMapScreen> createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMapScreen> {
  String bloodGroup = 'A+';
  List<Marker> markers = []; // List to store markers
  LatLng myLocation = const LatLng(30.679976, 85.327048);
  double radius = 1;
  MapController mapController = MapController();
  List<UserModel> _documents = [];
  UserModel? selectedDonor;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    // fetchNearbyUsers();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission =
        await GeolocatorPlatform.instance.checkPermission();
    if (permission == LocationPermission.denied) {}

    permission = await GeolocatorPlatform.instance.requestPermission();
    try {
      Position position =
          await GeolocatorPlatform.instance.getCurrentPosition();
      double latitude = position.latitude;
      double longitude = position.longitude;
      print('Latitude: $latitude, Longitude: $longitude');

      setState(() {
        myLocation = LatLng(latitude, longitude);
      });

      mapController.move(myLocation, 15.0);
      print("GOT LOCATION");
      // fetchNearbyUsers();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void fetchNearbyUsers() async {
    setState(() {
      markers = [];
      _documents = [];
    });
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("donor", isEqualTo: true)
        .where("bloodGroup", isEqualTo: bloodGroup)
        .get();
    List<Marker> updatedMarkers = [];

    for (var document in querySnapshot.docs) {
      var data = document.data() as Map<String, dynamic>;

      if (data['position'] == null) {
        continue;
      }
      var position = data['position']["geopoint"] as GeoPoint;
      // print(data);
      var userLatitude = position.latitude;
      var userLongitude = position.longitude;

      // Calculate the actual distance between the user and the location
      double distanceInKm = Geolocator.distanceBetween(
        userLatitude,
        userLongitude,
        myLocation.latitude,
        myLocation.longitude,
      );
      // print("---");
      // print(userLatitude);
      // print(userLongitude);
      // print(myLocation.latitude);
      // print(myLocation.longitude);
      // print(distanceInKm);
      // print("---");

      // Check if the location is within the desired radius
      if (distanceInKm <= radius * 1000) {
        // // Create a Marker for each nearby user
        updatedMarkers.add(
          Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(userLatitude, userLongitude),
            builder: (ctx) => InkWell(
              onTap: () {
                setState(() {
                  selectedDonor = UserModel.fromMap(data);
                });
              },
              child: Container(
                child: const Icon(
                  Icons.person_pin,
                  color: Colors.red,
                  size: 30.0,
                ),
              ),
            ),
          ),
        );
      } else {
        updatedMarkers.add(
          Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(userLatitude, userLongitude),
            builder: (ctx) => Container(
              child: const Icon(
                Icons.person_pin,
                color: Colors.blue,
                size: 30.0,
              ),
            ),
          ),
        );
      }
    }

    setState(() {
      if (querySnapshot.docs.isNotEmpty) {
        _documents.addAll(querySnapshot.docs
            .map((e) => UserModel.fromMap(e.data() as Map<dynamic, dynamic>))
            .toList());
        markers = updatedMarkers;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Nearby Donors'),
      ),
      body: Stack(
        children: [
          Container(
            child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: myLocation,
                  zoom: 2,
                  interactiveFlags: InteractiveFlag.all,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: myLocation, // center of 't Gooi
                        radius: radius * 1000,
                        useRadiusInMeter: true,
                        color: Colors.blue.withOpacity(0.3),
                        borderColor: Colors.blue.withOpacity(0.7),
                        borderStrokeWidth: 2,
                      )
                    ],
                  ),
                  MarkerLayer(
                    markers: markers, // Add the markers to the map
                  ),
                ]),
          ),
          _buildDonorCard(),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Search Radius: ${radius.toStringAsFixed(2)} km"),
                    // Add your sliders and buttons here
                    Slider(
                        value: radius,
                        min: 0.2,
                        max: 50,
                        onChanged: (double value) {
                          setState(() {
                            radius = value;
                          });
                        }),
                    Column(
                      children: [
                        BloodTypeFormSelect(
                          initialValue: 'A+',
                          onChanged: (newValue) {
                            setState(() {
                              bloodGroup = newValue!;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RButton(
                          buttonTitle: "search".tr,
                          onPressed: () => {fetchNearbyUsers()},
                        )
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  _buildDonorCard() {
    if (selectedDonor != null) {
      return Positioned(
        top: 0,
        left: 0,
        width: MediaQuery.of(context).size.width,
        child: Card(
          // padding:
          //     const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(children: [
              // Icon(Icons.),
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/blood_drop.svg',
                    height: 90,
                    color: Colors.red,
                  ),
                  Text(
                    selectedDonor!.bloodGroup,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedDonor?.fullName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Verified(verified: selectedDonor!.verified || false),
                  // IconButton(onPressed: onPressed, icon: icon)
                  Text(selectedDonor!.mobileNumber),
                  RIconButton(
                    onPressed: () async {
                      final url = 'tel:${selectedDonor!.mobileNumber}';
                      print(url);
                      try {
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url);
                        } else {
                          print("ERROR");
                          // Handle the case where the user's device doesn't support phone calls.
                          // You can display an error message or take appropriate action.
                        }
                      } catch (err) {
                        print(err);
                      }
                    },
                    icon: const Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    color: Colors.green,
                    text: "call".tr,
                  ),
                ],
              )
            ]),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
