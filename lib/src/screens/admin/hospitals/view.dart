import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/screens/admin/hospitals/create.dart';
import 'package:raktadaan/src/screens/admin/hospitals/update.dart';

class HospitalViewScreen extends StatelessWidget {
  const HospitalViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Hospitals'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const HospitalCreateScreen());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('hospitals').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var hospitals = snapshot.data!.docs;

          return ListView.builder(
            itemCount: hospitals.length,
            itemBuilder: (context, index) {
              var hospital = hospitals[index].data();
              var hospitalId = hospitals[index].id;

              return ListTile(
                title: Text(hospital['name']),
                subtitle: Text(
                  hospital['address'],
                  maxLines: 3,
                ),
                onTap: () {
                  // Add navigation or details screen for viewing a specific hospital
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to edit screen with hospitalId
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HospitalUpdateScreen(hospitalId: hospitalId),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Show confirmation dialog before deleting
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this hospital?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Delete the hospital from Firestore
                                  FirebaseFirestore.instance
                                      .collection('hospitals')
                                      .doc(hospitalId)
                                      .delete()
                                      .then((value) {
                                    Get.showSnackbar(const GetSnackBar(
                                      title: "Hospital deleted successfully",
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
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
