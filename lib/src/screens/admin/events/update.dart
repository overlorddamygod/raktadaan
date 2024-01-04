import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/screens/admin/events/create.dart';
import 'package:raktadaan/src/screens/home_screen.dart';
import 'package:raktadaan/src/widgets/widgets.dart';

class EventsUpdateScreen extends StatefulWidget {
  final String eventId;

  const EventsUpdateScreen({required this.eventId, super.key});

  @override
  State<EventsUpdateScreen> createState() => _EventsUpdateScreenState();
}

class _EventsUpdateScreenState extends State<EventsUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use TextEditingController for each TextFormField
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final formData = NewEventInsertFormData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch existing event data
    FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .get()
        .then((eventSnapshot) {
      var eventData = eventSnapshot.data() as Map<String, dynamic>;
      setState(() {
        formData.title = eventData['title'];
        formData.description = eventData['description'];
        formData.image = eventData['image'];
        formData.date = eventData['date'].toDate();

        // Set controller values
        titleController.text = formData.title;
        descriptionController.text = formData.description;
        imageController.text = formData.image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Event'.tr),
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
                      controller: titleController,
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
                      controller: descriptionController,
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
                      controller: imageController,
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
                        onPressed: onUpdate,
                        buttonTitle: 'update'.tr,
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
        'title': formData.title,
        'description': formData.description,
        'image': formData.image,
        'date': formData.date,
      };

      FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .update(updatedData)
          .then((value) {
        Get.showSnackbar(const GetSnackBar(
          title: "Event Updated Successfully",
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
