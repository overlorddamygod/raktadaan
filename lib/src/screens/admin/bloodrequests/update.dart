import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/widgets/widgets.dart';

class BloodRequestUpdateScreen extends StatefulWidget {
  final String requestId;

  const BloodRequestUpdateScreen({required this.requestId, Key? key})
      : super(key: key);

  @override
  _BloodRequestUpdateScreenState createState() =>
      _BloodRequestUpdateScreenState();
}

class _BloodRequestUpdateScreenState extends State<BloodRequestUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use TextEditingController for each TextFormField
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  bool isUrgent = false;
  // final SwitchListTileController urgentRequestController =
  //     SwitchListTileController();

  @override
  void initState() {
    super.initState();
    // Fetch existing blood request data
    FirebaseFirestore.instance
        .collection('user_blood_requests')
        .doc(widget.requestId)
        .get()
        .then((requestSnapshot) {
      var requestData = requestSnapshot.data() as Map<String, dynamic>;
      print(requestData);
      // Set controller values
      contactNumberController.text = requestData['contactNumber'];
      bloodTypeController.text = (requestData['bloodGroup']);
      cityController.text = (requestData['location']);
      // urgentRequestController.setValue(requestData['isUrgent']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Blood Request'),
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
                  BloodTypeFormSelect(
                    controller: bloodTypeController,
                  ),
                  const SizedBox(height: 10),
                  CityFormSelect(
                    controller: cityController,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: contactNumberController,
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
                        return 'Please enter contact number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  SwitchListTile(
                    title: Text('Urgent Request'),
                    value: isUrgent,
                    onChanged: (value) {
                      setState(() {
                        isUrgent = value;
                      });
                    },
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
    );
  }

  void onUpdate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var updatedData = {
        'bloodGroup': bloodTypeController.text,
        'location': cityController.text,
        'contactNumber': contactNumberController.text,
        'isUrgent': isUrgent,
      };

      FirebaseFirestore.instance
          .collection('user_blood_requests')
          .doc(widget.requestId)
          .update(updatedData)
          .then((value) {
        Get.showSnackbar(const GetSnackBar(
          title: "Blood Request Updated Successfully",
          message: " ",
          duration: Duration(seconds: 2),
        ));
        Navigator.pop(context);
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
