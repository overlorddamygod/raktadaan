import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/screens/admin/bloodrequests/update.dart';

class BloodRequestViewScreen extends StatelessWidget {
  const BloodRequestViewScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Blood Requests'),
        actions: [
          IconButton(
            onPressed: () {
              // Get.to(() => const BloodRequestCreateScreen());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user_blood_requests')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index].data() as Map<String, dynamic>;
              var requestId = requests[index].id;

              return ListTile(
                title: Text('Blood Group: ${request['bloodGroup']}'),
                subtitle: Text(
                  'Contact Number: ${request['contactNumber']}',
                  maxLines: 3,
                ),
                onTap: () {
                  // Add navigation or details screen for viewing a specific blood request
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to edit screen with requestId
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         BloodRequestUpdateScreen(requestId: requestId),
                        //   ),
                        // );
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
                                'Are you sure you want to delete this blood request?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Delete the blood request from Firestore
                                  FirebaseFirestore.instance
                                      .collection('user_blood_requests')
                                      .doc(requestId)
                                      .delete()
                                      .then((value) {
                                    Get.showSnackbar(const GetSnackBar(
                                      title:
                                          "Blood Request deleted successfully",
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
