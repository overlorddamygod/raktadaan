import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/controllers/controllers.dart';
import 'package:raktadaan/src/screens/home_screen.dart';
import 'package:raktadaan/src/widgets/widgets.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class UserUpdateFormData {
  String firstName = "";
  String lastName = "";
  String middleName = "";
  String mobileNumber = "";
  bool donor = false;
  String bloodGroup = "";
  String city = "";
  dynamic position;

  // String? documentUrl;
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use TextEditingController for each TextFormField
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  AuthController authController = Get.find();
  late String userId;
  late String docId;
  final formData = UserUpdateFormData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = authController.firestoreUser.value!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: userId)
        .get()
        .then((userSnapshot) {
      if (userSnapshot.docs.isEmpty) {
        Get.showSnackbar(const GetSnackBar(
          title: "Error",
          message: "Something went wrong",
          duration: Duration(seconds: 2),
        ));
        return;
      }
      if (userSnapshot.docs.length > 1) {
        Get.showSnackbar(const GetSnackBar(
          title: "Error",
          message: "Something went wrong",
          duration: Duration(seconds: 2),
        ));
        return;
      }
      var userData = userSnapshot.docs[0].data();
      print(userData);
      setState(() {
        docId = userSnapshot.docs[0].id;

        formData.firstName = userData['firstName'];
        formData.lastName = userData['lastName'];
        formData.middleName = userData['middleName'] ?? "";
        formData.mobileNumber = userData['mobileNumber'];
        formData.donor = userData['donor'];
        formData.bloodGroup = userData['bloodGroup'];
        formData.city = userData['city'] ?? "None";
        // formData.verified = userData['verified'] ?? false;
        // formData.documentUrl = userData['documentUrl'];
        // print(formData.documentUrl);

        firstNameController.text = formData.firstName;
        lastNameController.text = formData.lastName;
        middleNameController.text = formData.middleName;
        mobileNumberController.text = formData.mobileNumber;
        bloodGroupController.text = formData.bloodGroup;
        cityController.text = formData.city;
      });
    }).catchError((err) {
      print(err);
      Get.showSnackbar(const GetSnackBar(
        title: "Error",
        message: "Something went wrong",
        duration: Duration(seconds: 2),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'.tr),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        labelText: 'First Name',
                        prefixIcon: const Icon(Icons.person),
                        prefixIconColor: AppThemes.primaryColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        formData.firstName = newValue!;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: middleNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        labelText: 'Middle Name',
                        prefixIcon: const Icon(Icons.person),
                        prefixIconColor: AppThemes.primaryColor,
                      ),
                      // Add validator and onSaved for middle name
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        labelText: 'Last Name',
                        prefixIcon: const Icon(Icons.person),
                        prefixIconColor: AppThemes.primaryColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        formData.lastName = newValue!;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: mobileNumberController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        labelText: 'Mobile Number',
                        prefixIcon: const Icon(Icons.phone),
                        prefixIconColor: AppThemes.primaryColor,
                      ),
                      // Add validator and onSaved for mobile number
                    ),
                    const SizedBox(height: 15),
                    BloodTypeFormSelect(
                      controller: bloodGroupController,
                      onSaved: (value) {
                        formData.bloodGroup = value!;
                      },
                    ),
                    const SizedBox(height: 15),
                    SwitchListTile(
                      title: const Text('Is donor?'),
                      value: formData.donor,
                      onChanged: (value) {
                        setState(() {
                          formData.donor = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    CityFormSelect(
                      controller: cityController,
                      onSaved: (value) {
                        formData.city = value!;
                      },
                    ),
                    const SizedBox(height: 15),

                    RIconButton(
                        text: "Give Current Location",
                        icon: const Icon(Icons.share_location),
                        color: formData.position == null
                            ? Colors.blue
                            : Colors.green,
                        onPressed: () async {
                          await getCurrentLocation();
                        }),
                    // const Text(
                    //   "Document",
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // Container(
                    //   // height: 200,
                    //   // width: 200,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.grey),
                    //   ),
                    //   child: formData.documentUrl != null
                    //       ? Image.network(formData.documentUrl!,
                    //           fit: BoxFit.cover)
                    //       : const Center(child: Text("No Document Provided")),
                    // ),
                    const SizedBox(height: 15),
                    Container(
                      child: RButton(
                        onPressed: onUpdate,
                        buttonTitle: 'Update Profile'.tr,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onUpdate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var updatedData = {
        'firstName': formData.firstName,
        'lastName': formData.lastName,
        'middleName': formData.middleName,
        'mobileNumber': formData.mobileNumber,
        'donor': formData.donor,
        'bloodGroup': formData.bloodGroup,
        'city': formData.city,
      };

      if (formData.position != null) {
        updatedData['position'] = formData.position;
      }

      FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .update(updatedData)
          .then((value) {
        Get.showSnackbar(const GetSnackBar(
          title: "Profile Updated Successfully",
          message: " ",
          duration: Duration(seconds: 2),
        ));

        authController.getFirestoreUser();
        Get.offAll(() => const HomeScreen());
      }).catchError((error) {
        Get.showSnackbar(const GetSnackBar(
          title: "Error",
          message: "Something went wrong",
          duration: Duration(seconds: 2),
        ));
      });
    }
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

      formData.position =
          GeoFlutterFire().point(latitude: latitude, longitude: longitude).data;

      setState(() {});
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}
