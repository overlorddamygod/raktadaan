import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/screens/home_screen.dart';
import 'package:raktadaan/src/widgets/widgets.dart';

class UserUpdateScreen extends StatefulWidget {
  final String userId;

  const UserUpdateScreen({required this.userId, Key? key}) : super(key: key);

  @override
  State<UserUpdateScreen> createState() => _UserUpdateScreenState();
}

class UserUpdateFormData {
  String firstName = "";
  String lastName = "";
  String middleName = "";
  String mobileNumber = "";
  String email = "";
  bool donor = false;
  String bloodGroup = "";
  String city = "";
  bool verified = false;
  String? documentUrl;
  String? disease;
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use TextEditingController for each TextFormField
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController diseaseController = TextEditingController();

  final formData = UserUpdateFormData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get()
        .then((userSnapshot) {
      var userData = userSnapshot.data() as Map<String, dynamic>;
      print(userData);
      setState(() {
        formData.firstName = userData['firstName'];
        formData.lastName = userData['lastName'];
        formData.middleName = userData['middleName'] ?? "";
        formData.mobileNumber = userData['mobileNumber'];
        formData.email = userData['email'];
        formData.donor = userData['donor'];
        formData.bloodGroup = userData['bloodGroup'];
        formData.city = userData['city'] ?? "None";
        formData.verified = userData['verified'] ?? false;
        formData.documentUrl = userData['documentUrl'];
        formData.disease = userData['disease'];
        // print(formData.documentUrl);

        firstNameController.text = formData.firstName;
        lastNameController.text = formData.lastName;
        middleNameController.text = formData.middleName;
        mobileNumberController.text = formData.mobileNumber;
        emailController.text = formData.email;
        bloodGroupController.text = formData.bloodGroup;
        cityController.text = formData.city;
        diseaseController.text = formData.disease ?? "";
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
        title: const Text('Update User Info'),
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
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        prefixIconColor: AppThemes.primaryColor,
                      ),
                      // Add validator and onSaved for email
                    ),
                    const SizedBox(height: 15),
                    BloodTypeFormSelect(
                      controller: bloodGroupController,
                      onSaved: (value) {
                        formData.bloodGroup = value!;
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
                    SwitchListTile(
                      title: const Text('Verified'),
                      value: formData.verified,
                      onChanged: (value) {
                        setState(() {
                          formData.verified = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: diseaseController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        labelText: 'Disease',
                        prefixIcon: const Icon(Icons.email),
                        prefixIconColor: AppThemes.primaryColor,
                      ),
                      // Add validator and onSaved for email
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Document",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      // height: 200,
                      // width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: formData.documentUrl != null
                          ? Image.network(formData.documentUrl!,
                              fit: BoxFit.cover)
                          : const Center(child: Text("No Document Provided")),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      child: RButton(
                        onPressed: onUpdate,
                        buttonTitle: 'Update',
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
      print(formData.bloodGroup);
      var updatedData = {
        'firstName': formData.firstName,
        'lastName': formData.lastName,
        'middleName': formData.middleName,
        'mobileNumber': formData.mobileNumber,
        'email': formData.email,
        'donor': formData.donor,
        'bloodGroup': formData.bloodGroup,
        'city': formData.city,
        'verified': formData.verified,
        'disease': formData.disease,
      };

      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update(updatedData)
          .then((value) {
        Get.showSnackbar(const GetSnackBar(
          title: "User Info Updated Successfully",
          message: " ",
          duration: Duration(seconds: 2),
        ));
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
}
