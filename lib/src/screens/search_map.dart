// import 'dart:html';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:geolocator/geolocator.dart';
// import 'package:geolocator_web/geolocator_web.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import 'package:latlong2/latlong.dart';
import 'package:raktadaan/src/widgets/widgets.dart';

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
  List<Object> _documents = [];

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
            builder: (ctx) => Container(
              child: const Icon(
                Icons.person_pin,
                color: Colors.red,
                size: 30.0,
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
        _documents.addAll(querySnapshot.docs.map((e) => {}));
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
                    onTap: (tapPosition, point) {
                      print("SAD");
                      print(point);
                      final geo = GeoFlutterFire();

                      // myLocation = point;
                      FirebaseFirestore.instance.collection("users").add({
                        "name": "John Doe",
                        "position": geo
                            .point(
                                latitude: point.latitude,
                                longitude: point.longitude)
                            .data
                      });
                      // fetchNearbyUsers();
                    }),
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
                  // StreamBuilder<List<DocumentSnapshot>>(
                  //   stream: fetchNearbyUsersStream(myLocation, radius),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasError) {
                  //       return Text(snapshot.error.toString());
                  //     }
                  //     if (snapshot.hasData) {
                  //       // Use the data to build your UI
                  //       // Example: Create markers based on snapshot data
                  //       List<DocumentSnapshot> documentList = snapshot.data!;

                  //       return MarkerLayer(
                  //           markers: documentList.map((e) {
                  //         var data = e.data() as Map<String, dynamic>;
                  //         var position =
                  //             data['position']["geopoint"] as GeoPoint;
                  //         // print(data);
                  //         var userLatitude = position.latitude;
                  //         var userLongitude = position.longitude;

                  //         // Calculate the actual distance between the user and the location
                  //         double distanceInKm = Geolocator.distanceBetween(
                  //           userLatitude,
                  //           userLongitude,
                  //           myLocation.latitude,
                  //           myLocation.longitude,
                  //         );

                  //         // Check if the location is within the desired radius
                  //         if (distanceInKm <= radius * 1000) {
                  //           // // Create a Marker for each nearby user
                  //           return Marker(
                  //             width: 30.0,
                  //             height: 30.0,
                  //             point: LatLng(userLatitude, userLongitude),
                  //             builder: (ctx) => Container(
                  //               child: const Icon(
                  //                 Icons.person_pin,
                  //                 color: Colors.red,
                  //                 size: 30.0,
                  //               ),
                  //             ),
                  //           );
                  //         }
                  //         return Marker(
                  //           width: 30.0,
                  //           height: 30.0,
                  //           point: LatLng(userLatitude, userLongitude),
                  //           builder: (ctx) => Container(
                  //             child: const Icon(
                  //               Icons.person_pin,
                  //               color: Colors.blue,
                  //               size: 30.0,
                  //             ),
                  //           ),
                  //         );
                  //       }).toList());
                  //     } else {
                  //       // Handle the case when data is not available yet
                  //       return CircularProgressIndicator();
                  //     }
                  //   },
                  // ),
                  MarkerLayer(
                    markers: markers, // Add the markers to the map
                  ),
                ]),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
}
