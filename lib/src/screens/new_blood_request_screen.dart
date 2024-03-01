import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/constants/config.dart';
import 'package:raktadaan/src/controllers/controllers.dart';
import 'package:raktadaan/src/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/widgets.dart';

class NewBloodRequestScreen extends StatefulWidget {
  const NewBloodRequestScreen({super.key});

  static const routeName = '/newbloodrequest';

  @override
  State<NewBloodRequestScreen> createState() => _NewBloodRequestScreenState();
}

class NewBloodRequestFormData {
  String bloodGroup = '';
  String contactNumber = '';
  bool isUrgent = false;
  String location = 'Lalitpur';
  Timestamp requestAt = Timestamp.now();
}

class _NewBloodRequestScreenState extends State<NewBloodRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final formData = NewBloodRequestFormData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Blood Request'.tr),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Column(
              children: [
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(children: [
                    BloodTypeFormSelect(
                      onSaved: (newValue) {
                        formData.bloodGroup = newValue!;
                      },
                    ),
                    const SizedBox(height: 10),
                    CityFormSelect(
                      initialValue: formData.location,
                      onSaved: (newValue) {
                        formData.location = newValue!;
                      },
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: formData.isUrgent,
                          onChanged: (newValue) {
                            setState(() {
                              formData.isUrgent = newValue!;
                            });
                          },
                        ),
                        Text('Is Urgent'.tr),
                      ],
                    ),
                    TextFormField(
                      // validator: ,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        labelText: 'Contact No.',
                        prefixIcon: const Icon(Icons.phone),
                        prefixIconColor: AppThemes.primaryColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter contact number';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        formData.contactNumber = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      // margin: const EdgeInsets.symmetric(vertical: 15),
                      child: RButton(
                        onPressed: onSubmit,
                        buttonTitle: 'submit'.tr,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(formData.bloodGroup);
      print(formData.contactNumber);
      print(formData.isUrgent);
      print(formData.location);
      print(formData.requestAt);

      var requestData = {
        'bloodGroup': formData.bloodGroup,
        'contactNumber': formData.contactNumber,
        'isUrgent': formData.isUrgent,
        'location': formData.location,
      };

      try {
        var url = Config.SERVER_URL;
        var response = await http.post(
          Uri.parse('$url/bloodrequest'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestData),
        );

        if (AuthController.to.isLoggedIn.value) {
          requestData['userId'] = AuthController.to.currentUser!.uid;
        }

        if (response.statusCode == 200) {
          // Blood request submitted successfully
          Get.showSnackbar(const GetSnackBar(
            title: "Blood Request Submitted Successfully",
            message: " ",
            duration: Duration(seconds: 2),
          ));
          Get.offAll(() => const HomeScreen());
        } else {
          // Handle error from the server
          Get.showSnackbar(const GetSnackBar(
            title: "Error",
            message: "Something went wrong",
            duration: Duration(seconds: 2),
          ));
        }
      } catch (error) {
        print(error);
        // Handle network or other errors
        Get.showSnackbar(const GetSnackBar(
          title: "Error",
          message: "Something went wrong",
          duration: Duration(seconds: 2),
        ));
      }

      //   if (FirebaseAuth.instance.currentUser?.uid != null) {
      //     requestData['uid'] = FirebaseAuth.instance.currentUser!.uid;
      //   }

      //   FirebaseFirestore.instance
      //       .collection('user_blood_requests')
      //       .add(requestData)
      //       .then((value) {
      //     Get.showSnackbar(const GetSnackBar(
      //       title: "Blood Request Submitted Successfully",
      //       message: " ",
      //       duration: Duration(seconds: 2),
      //     ));
      //     Get.offAll(() => const HomeScreen());
      //   }).catchError((error) {
      //     Get.showSnackbar(const GetSnackBar(
      //       title: "Error",
      //       message: "Something went wrong",
      //       duration: Duration(seconds: 2),
      //     ));
      //   });
      // }
    }
  }
}
