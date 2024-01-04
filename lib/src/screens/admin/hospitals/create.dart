import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/screens/home_screen.dart';
import 'package:raktadaan/src/widgets/widgets.dart';

class HospitalCreateScreen extends StatefulWidget {
  const HospitalCreateScreen({super.key});

  static const routeName = '/newhospital';

  @override
  State<HospitalCreateScreen> createState() => _HospitalCreateScreenState();
}

class NewHospitalCreateFormData {
  String name = "";
  String address = "";
  String contact = "";
}

class _HospitalCreateScreenState extends State<HospitalCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final formData = NewHospitalCreateFormData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Hospital Info'.tr),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      labelText: 'Hospital Name',
                      prefixIcon: const Icon(Icons.text_fields),
                      prefixIconColor: AppThemes.primaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter hospital name';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      formData.name = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      labelText: 'Address',
                      prefixIcon: const Icon(Icons.location_on),
                      prefixIconColor: AppThemes.primaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter hospital address';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      formData.address = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      labelText: 'Contact Number',
                      prefixIcon: const Icon(Icons.phone),
                      prefixIconColor: AppThemes.primaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter hospital contact number';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      formData.contact = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: RButton(
                      onPressed: onSubmit,
                      buttonTitle: 'Submit'.tr,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var requestData = {
        'name': formData.name,
        'address': formData.address,
        'contact': formData.contact,
      };

      FirebaseFirestore.instance
          .collection('hospitals')
          .add(requestData)
          .then((value) {
        Get.showSnackbar(const GetSnackBar(
          title: "New Hospital Info Submitted Successfully",
          message: " ",
          duration: Duration(seconds: 2),
        ));
        Navigator.pop(context); // Close dialog
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
