import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/screens/home_screen.dart';
import 'package:raktadaan/src/widgets/widgets.dart';

class EventsCreateScreen extends StatefulWidget {
  const EventsCreateScreen({super.key});

  static const routeName = '/newbloodrequest';

  @override
  State<EventsCreateScreen> createState() => _EventsCreateScreenState();
}

class NewEventInsertFormData {
  String title = "";
  String description = "";
  DateTime date = DateTime.now();
  String image = "";
}

class _EventsCreateScreenState extends State<EventsCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final formData = NewEventInsertFormData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Event'.tr),
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        labelText: 'Title',
                        prefixIcon: const Icon(Icons.text_fields),
                        prefixIconColor: AppThemes.primaryColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter event title';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        formData.title = newValue!;
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
                        labelText: 'Description',
                        prefixIcon: const Icon(Icons.description),
                        prefixIconColor: AppThemes.primaryColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter event description';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        formData.description = newValue!;
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
                        labelText: 'Event Image',
                        prefixIcon: const Icon(Icons.image),
                        prefixIconColor: AppThemes.primaryColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter event image link';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        formData.image = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InputDatePickerFormField(
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                      initialDate: formData.date,
                      onDateSubmitted: (DateTime value) {
                        setState(() {
                          formData.date = value;
                        });
                      },
                      onDateSaved: (DateTime value) {
                        setState(() {
                          formData.date = value;
                        });
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

  onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var requestData = {
        'title': formData.title,
        'description': formData.description,
        'image': formData.image,
        'date': formData.date,
      };

      FirebaseFirestore.instance
          .collection('events')
          .add(requestData)
          .then((value) {
        Get.showSnackbar(const GetSnackBar(
          title: "New Event Submitted Successfully",
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
