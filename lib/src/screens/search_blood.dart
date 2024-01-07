import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/models/user_model.dart';
import 'package:raktadaan/src/widgets/helpers.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/widgets.dart';

class SearchBloodScreen extends StatefulWidget {
  const SearchBloodScreen({super.key});

  @override
  State<SearchBloodScreen> createState() => _SearchBloodScreenState();
}

class _SearchBloodScreenState extends State<SearchBloodScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  List<UserModel> _documents = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_hasMore && !_isLoading) {
          _fetchData();
        }
      }
    });
  }

  String bloodGroup = 'A+';
  String city = "Lalitpur";

  Future<void> _fetchDataInitial() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot querySnapshot;
    if (_documents.isEmpty) {
      querySnapshot = await _firestore
          .collection('users')
          .where("donor", isEqualTo: true)
          .where("bloodGroup", isEqualTo: bloodGroup)
          .where("city", isEqualTo: city)
          .limit(10)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection('users')
          .where("donor", isEqualTo: true)
          .where("bloodGroup", isEqualTo: bloodGroup)
          .where("city", isEqualTo: city)
          .startAfterDocument(_documents.last as DocumentSnapshot<Object?>)
          .limit(10)
          .get();
    }
    setState(() {
      _isLoading = false;
      if (querySnapshot.docs.isNotEmpty) {
        _documents.addAll(querySnapshot.docs
            .map((e) => UserModel.fromMap(e.data() as Map<dynamic, dynamic>))
            .toList());
      } else {
        _hasMore = false;
      }
    });
  }

  Future<void> _fetchData() async {
    if (_hasMore) {
      setState(() {
        _isLoading = true;
      });

      QuerySnapshot querySnapshot;
      if (_documents.isEmpty) {
        querySnapshot = await _firestore
            .collection('users')
            .where("donor", isEqualTo: true)
            .where("bloodGroup", isEqualTo: bloodGroup)
            .where("city", isEqualTo: city)
            .limit(10)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection('users')
            .where("donor", isEqualTo: true)
            .where("bloodGroup", isEqualTo: bloodGroup)
            .where("city", isEqualTo: city)
            .startAfterDocument(_documents.last as DocumentSnapshot<Object?>)
            .limit(10)
            .get();
      }
      print(city);
      setState(() {
        for (var document in querySnapshot.docs) {
          print(document.data());
        }
        _isLoading = false;
        if (querySnapshot.docs.isNotEmpty) {
          _documents.addAll(querySnapshot.docs
              .map((e) => UserModel.fromMap(e.data() as Map<dynamic, dynamic>))
              .toList());
        } else {
          _hasMore = false;
        }
      });
    }
  }

  void searchBloodDoonors() async {
    setState(() {
      _hasSearched = true;
      _hasMore = true;
      _documents = [];
      _fetchData();
    });
    // try {
    //   var donorUsers = await FirebaseFirestore.instance
    //       .collection('users')
    //       .where("donor", isEqualTo: true)
    //       .where("bloodGroup", isEqualTo: bloodGroup)
    //       .get();

    //   setState(() {
    //     donors =
    //         donorUsers.docs.map((e) => UserModel.fromMap(e.data())).toList();
    //   });
    // } catch (err) {
    //   print(err);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search_for_blood_donors'.tr),
      ),
      // input element to search according to blood type and location
      // search button
      // list of donors
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Column(
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
                CityFormSelect(
                  initialValue: city,
                  onChanged: (newValue) {
                    setState(() {
                      city = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                RButton(
                  buttonTitle: "search".tr,
                  onPressed: () => {searchBloodDoonors()},
                )
              ],
            ),
          ),
          Expanded(
            child: _documents.isEmpty
                ? (_hasSearched
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No donors found!'),
                        ),
                      )
                    : const SizedBox())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _documents.length + (_hasMore ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == _documents.length) {
                        if (_hasMore) {
                          if (_hasSearched) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('No more items!'.tr),
                              ),
                            );
                          }
                          return const SizedBox();
                        }
                        return loader();
                      }
                      final donor = _documents[index];
                      return Card(
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
                                  bloodGroup,
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
                                  donor.fullName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Verified(verified: donor.verified),
                                // IconButton(onPressed: onPressed, icon: icon)
                                Text(donor.mobileNumber),
                                RIconButton(
                                  onPressed: () async {
                                    final url = 'tel:${donor.mobileNumber}';
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
                              ],
                            )
                          ]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
