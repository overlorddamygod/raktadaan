import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/screens/admin/users/update.dart';

class UsersViewScreen extends StatelessWidget {
  const UsersViewScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // Get.to(() => const BloodRequestCreateScreen());
        //     },
        //     icon: const Icon(Icons.add),
        //   ),
        // ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index].data() as Map<String, dynamic>;
              var userId = users[index].id;
              print("USER $userId");
              return ListTile(
                title: Text('Name: ${user['firstName']} ${user['lastName']}'),
                subtitle: Text(
                  'Blood Group: ${user['bloodGroup']}, City: ${user['city']}',
                  maxLines: 3,
                ),
                onTap: () {
                  // Add navigation or details screen for viewing a specific user
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserUpdateScreen(userId: userId),
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
                                'Are you sure you want to delete this user?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Delete the user from Firestore
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .delete()
                                      .then((value) {
                                    Get.showSnackbar(const GetSnackBar(
                                      title: "User deleted successfully",
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
