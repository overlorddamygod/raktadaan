import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'package:geolocator/geolocator.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    print("LOCATIONNN");
    try {
      LocationPermission permission =
          await GeolocatorPlatform.instance.checkPermission();
      if (permission == LocationPermission.denied) {
        // Get.showSnackbar(const GetSnackBar(
        //   title: "Need location permission",
        //   message: "Something went wrong",
        //   duration: Duration(seconds: 2),
        // ));
        // Get.offAll(() => const HomeScreen());
        // return;
      }

      permission = await GeolocatorPlatform.instance.requestPermission();

      if (permission == LocationPermission.denied) {
        Get.showSnackbar(const GetSnackBar(
          title: "Need location permission",
          message: "Something went wrong",
          duration: Duration(seconds: 2),
        ));
        // Get.back();
        return;
      }
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
      Get.showSnackbar(const GetSnackBar(
        title: "Error getting location",
        message: "Something went wrong",
        duration: Duration(seconds: 2),
      ));
    }
  }

  int getPrecision(double km) {
    if (km <= 0.00477) {
      return 9;
    } else if (km <= 0.0382) {
      return 8;
    } else if (km <= 0.153) {
      return 7;
    } else if (km <= 1.22) {
      return 6;
    } else if (km <= 4.89) {
      return 5;
    } else if (km <= 39.1) {
      return 4;
    } else if (km <= 156) {
      return 3;
    } else if (km <= 1250) {
      return 2;
    } else {
      return 1;
    }
  }

  Future<List<UserModel>> getDocumentsStartingWith(
      List<String> prefixes) async {
    List<UserModel> result = [];

    for (String prefix in prefixes) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("donor", isEqualTo: true)
          .where("bloodGroup", isEqualTo: bloodGroup)
          .where('position.geohash', isGreaterThanOrEqualTo: prefix)
          .where('position.geohash',
              isLessThan:
                  prefix + 'z') // assuming z is the next character in ASCII
          .get();

      result.addAll(querySnapshot.docs
          .map((e) => UserModel.fromMap(e.data() as Map<dynamic, dynamic>)));
    }

    return result;
  }

  void fetchNearbyUsersCustom() async {
    // Get the length of hash to be used for querying
    final precision = getPrecision(radius);

    // Current user's location
    GeoFirePoint center = GeoFlutterFire()
        .point(latitude: myLocation.latitude, longitude: myLocation.longitude);

    // Chop the hash to the desired length
    final centerHash = center.hash.substring(0, precision);

    // Get neighbors of the user's location's hash
    final neighbours = Set<String>.from(
      GeoFirePoint.neighborsOf(hash: centerHash)..add(centerHash),
    ).toList();

    var users = await getDocumentsStartingWith(neighbours);

    // List of markers from the list of users returned to add in map
    List<Marker> updatedMarkers = [];
    // List of user to store users within the radius
    List<UserModel> filteredUsersList = [];

    for (var user in users) {
      if (user.position == null) {
        continue;
      }

      var userLatitude = user.position!.geopoint.latitude;
      var userLongitude = user.position!.geopoint.longitude;

      // Calculate the actual distance between the user and the location
      double distanceInKm = Geolocator.distanceBetween(
        userLatitude,
        userLongitude,
        myLocation.latitude,
        myLocation.longitude,
      );

      // Check if the location is within the desired radius
      if (distanceInKm <= radius * 1000) {
        updatedMarkers.add(
          Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(userLatitude, userLongitude),
            builder: (ctx) => InkWell(
              onTap: () {
                setState(() {
                  selectedDonor = user;
                });
              },
              child: const Icon(
                Icons.person_pin,
                color: Colors.red,
                size: 30.0,
              ),
            ),
          ),
        );
        // Add the user to the filtered list
        filteredUsersList.add(user);
      } else {
        updatedMarkers.add(
          Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(userLatitude, userLongitude),
            builder: (ctx) => const Icon(
              Icons.person_pin,
              color: Colors.blue,
              size: 30.0,
            ),
          ),
        );
      }
    }
    setState(() {
      _documents.clear();
      _documents.addAll(filteredUsersList);
      markers = updatedMarkers;
    });
  }

  void fetchNearbyUsers() async {
    // f();
    setState(() {
      markers = [];
      _documents = [];
    });

    // Create a geoFlutterFire [library] instance
    final geo = GeoFlutterFire();

    // Firebase Collection Reference
    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .where("donor", isEqualTo: true)
        .where("bloodGroup", isEqualTo: bloodGroup);

    // Current user's location
    GeoFirePoint center = geo.point(
        latitude: myLocation.latitude, longitude: myLocation.longitude);

    // Fetch the users near the current user's radius
    List<dynamic> usersList = await geo
        .collection(collectionRef: collectionRef)
        .within(center: center, radius: radius, field: "position")
        .first;

    // Create a list of markers from the list of users returned to add in map
    List<Marker> updatedMarkers = [];

    // To store filtered users list
    List<UserModel> filteredUsersList = [];

    for (var userData in usersList) {
      var data = UserModel.fromMap(userData.data());

      if (data.position == null) {
        continue;
      }
      var position = data.position!.geopoint;

      var userLatitude = position.latitude;
      var userLongitude = position.longitude;

      // Calculate the actual distance between the user and the location
      double distanceInKm = Geolocator.distanceBetween(
        userLatitude,
        userLongitude,
        myLocation.latitude,
        myLocation.longitude,
      );

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
                  selectedDonor = data;
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
        // Add the user to the filtered list
        filteredUsersList.add(data);
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
      if (filteredUsersList.isNotEmpty) {
        _documents.addAll(filteredUsersList);
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
                          onPressed: () => {fetchNearbyUsersCustom()},
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
                    selectedDonor!.fullName,
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
