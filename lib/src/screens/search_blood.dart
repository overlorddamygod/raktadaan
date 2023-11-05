import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/models/user_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/widgets.dart';

class SearchBloodScreen extends StatefulWidget {
  const SearchBloodScreen({super.key});

  @override
  State<SearchBloodScreen> createState() => _SearchBloodScreenState();
}

class _SearchBloodScreenState extends State<SearchBloodScreen> {
  String bloodGroup = 'A+';

  List<UserModel> donors = [];

  void searchBloodDoonors() async {
    try {
      var donorUsers = await FirebaseFirestore.instance
          .collection('users')
          .where("donor", isEqualTo: true)
          .where("bloodGroup", isEqualTo: bloodGroup)
          .get();

      setState(() {
        donors =
            donorUsers.docs.map((e) => UserModel.fromMap(e.data())).toList();
      });
    } catch (err) {
      print(err);
    }
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
                RButton(
                  buttonTitle: "search".tr,
                  onPressed: () => {searchBloodDoonors()},
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: donors.length,
              itemBuilder: (BuildContext context, int index) {
                final donor = donors[index];
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
                                fontWeight: FontWeight.bold, fontSize: 17),
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
                            text: "call".tr,
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
