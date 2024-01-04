import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/screens/home_screen.dart';
import 'package:raktadaan/src/widgets/widgets.dart';

class HospitalUpdateScreen extends StatefulWidget {
  final String hospitalId;

  const HospitalUpdateScreen({required this.hospitalId, super.key});

  @override
  State<HospitalUpdateScreen> createState() => _HospitalUpdateScreenState();
}

class NewHospitalCreateFormData {
  String name = "";
  String address = "";
  String contact = "";
}

class _HospitalUpdateScreenState extends State<HospitalUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use TextEditingController for each TextFormField
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  final formData = NewHospitalCreateFormData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch existing hospital data
    FirebaseFirestore.instance
        .collection('hospitals')
        .doc(widget.hospitalId)
        .get()
        .then((hospitalSnapshot) {
      var hospitalData = hospitalSnapshot.data() as Map<String, dynamic>;
      setState(() {
        formData.name = hospitalData['name'];
        formData.address = hospitalData['address'];
        formData.contact = hospitalData['contact'];

        // Set controller values
        nameController.text = formData.name;
        addressController.text = formData.address;
        contactController.text = formData.contact;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Hospital Info'.tr),
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
                    TextFormField(
                      controller: nameController,
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
                      controller: addressController,
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
                      controller: contactController,
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
                        onPressed: onUpdate,
                        buttonTitle: 'Update'.tr,
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

  void onUpdate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var updatedData = {
        'name': formData.name,
        'address': formData.address,
        'contact': formData.contact,
      };

      FirebaseFirestore.instance
          .collection('hospitals')
          .doc(widget.hospitalId)
          .update(updatedData)
          .then((value) {
        Get.showSnackbar(const GetSnackBar(
          title: "Hospital Info Updated Successfully",
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
