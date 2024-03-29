import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';

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

enum MapState { Searching, LocationSelect }

class _SearchMapState extends State<SearchMapScreen> {
  String bloodGroup = 'A+';
  List<Marker> markers = []; // List to store markers
  LatLng myLocation = const LatLng(27.672822, 85.333250);
  double radius = 1;
  MapController mapController = MapController();
  List<UserModel> _documents = [];
  UserModel? selectedDonor;
  MapState mapState = MapState.LocationSelect;
  LatLng centerLocation = const LatLng(27.672822, 85.333250);
  MapController selectLocationMapController = MapController();

  Future<void> getCurrentLocation() async {
    print("LOCATIONNN");
    try {
      LocationPermission permission =
          await GeolocatorPlatform.instance.checkPermission();
      if (permission == LocationPermission.denied) {
        // Get.showSnackbar(const GetSnackBar(
        //   title: "Need location permission1",
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
        centerLocation = LatLng(latitude, longitude);
      });

      selectLocationMapController.move(centerLocation, 15.0);
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

  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude));
    var c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  static _toRadians(double degree) {
    return degree * pi / 180;
  }

  void fetchNearbyUsersCustom() async {
    setState(() {
      selectedDonor = null;
    });
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

    // Query firebase for users with the the geohashes
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
      double distanceInKm = distanceBetween(
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/blood_drop.svg',
                    height: 90,
                    color: Colors.red,
                  ),
                  Text(
                    user.bloodGroup,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        // Add the user to the filtered list
        filteredUsersList.add(user);
      } else {
        // updatedMarkers.add(
        //   Marker(
        //     width: 30.0,
        //     height: 30.0,
        //     point: LatLng(userLatitude, userLongitude),
        //     builder: (ctx) => const Icon(
        //       Icons.person_pin,
        //       color: Colors.blue,
        //       size: 30.0,
        //     ),
        //   ),
        // );
      }
    }

    if (filteredUsersList.isEmpty) {
      Get.showSnackbar(const GetSnackBar(
        title: "No Donors Found",
        message: "No donors found in the selected radius",
        duration: Duration(seconds: 2),
      ));
    }
    print(filteredUsersList);
    setState(() {
      _documents.clear();
      _documents.addAll(filteredUsersList);
      markers = updatedMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (mapState == MapState.LocationSelect) {
          Get.back();
          return Future.value(false);
        }
        setState(() {
          mapState = MapState.LocationSelect;
        });
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: mapState == MapState.LocationSelect
              ? Text("Select Your Location".tr)
              : Text('Search Nearby Donors'.tr),
        ),
        body: mapState == MapState.Searching
            ? _buildSearchArea()
            : _buildLocationSelect(),
        floatingActionButton: mapState == MapState.LocationSelect
            ? FloatingActionButton(
                onPressed: () {
                  getCurrentLocation();
                },
                child: const Icon(Icons.location_searching),
                tooltip: "Get Current Location".tr,
              )
            : null,
      ),
    );
  }

  _buildLocationSelect() {
    return Stack(
      children: [
        FlutterMap(
          mapController: selectLocationMapController,
          options: MapOptions(
            center: const LatLng(27.7172, 85.3240),
            zoom: 10,
            interactiveFlags: InteractiveFlag.all,
            onPositionChanged: (position, hasGesture) {
              setState(() {
                centerLocation = position.center!;
                // mapController.move(centerLocation, 15);
              });
            },
            onMapReady: () {
              selectLocationMapController.move(centerLocation, 15);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            CircleLayer(
              circles: [
                // CircleMarker(
                //   point: myLocation, // center of 't Gooi
                //   radius: radius * 1000,
                //   useRadiusInMeter: true,
                //   color: Colors.blue.withOpacity(0.3),
                //   borderColor: Colors.blue.withOpacity(0.7),
                //   borderStrokeWidth: 2,
                // )
              ],
            ),
            MarkerLayer(
              markers: [
                // marker at center
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: centerLocation,
                  rotate: false,
                  builder: (ctx) => const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                ),
              ], // Add the markers to the map
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: RButton(
              buttonTitle: "Select Location".tr,
              onPressed: () => {
                setState(() {
                  myLocation = centerLocation;
                  mapState = MapState.Searching;
                })
              },
            ),
          ),
        ),
      ],
    );
  }

  _buildSearchArea() {
    return Stack(
      children: [
        Container(
          child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: myLocation,
                zoom: 2,
                interactiveFlags: InteractiveFlag.all,
                onMapReady: () => {mapController.move(myLocation, 15)},
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                  Text(
                      "${"Search Radius".tr}: ${radius.toStringAsFixed(2)} ${"km".tr}"),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDonor!.fullName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              selectedDonor = null;
                            });
                          },
                        ),
                      ],
                    ),
                    Verified(verified: selectedDonor!.verified || false),
                    Text('Age: ${selectedDonor!.age}'),
                    // IconButton(onPressed: onPressed, icon: icon)
                    Text('Mobile No: ${selectedDonor!.mobileNumber}'),
                    if (selectedDonor!.disease != null &&
                        selectedDonor!.disease != '')
                      Text('Disease: ${selectedDonor!.disease!}'),
                    Text('Last Transfusion: ${selectedDonor!.lastTransfusion}'),

                    SizedBox(
                      width: 100,
                      child: RIconButton(
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
                        text: "Call".tr,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
