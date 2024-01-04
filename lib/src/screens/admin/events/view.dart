import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/screens/admin/events/create.dart';
import 'package:raktadaan/src/screens/admin/events/update.dart';

class EventsViewScreen extends StatelessWidget {
  const EventsViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Events'),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const EventsCreateScreen());
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var event = events[index].data();
              var eventId = events[index].id;

              return ListTile(
                title: Text(event['title']),
                subtitle: Text(
                  event['description'],
                  maxLines: 3,
                ),
                onTap: () {
                  // Add navigation or details screen for viewing a specific event
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to edit screen with eventId
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventsUpdateScreen(eventId: eventId),
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
                                'Are you sure you want to delete this event?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Delete the event from Firestore

                                  FirebaseFirestore.instance
                                      .collection('events')
                                      .doc(eventId)
                                      .delete()
                                      .then((value) {
                                    Get.showSnackbar(const GetSnackBar(
                                      title: "Event deleted successfully",
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
