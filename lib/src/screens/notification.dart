import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/screens/event_screen.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'.tr),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('notifications').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notificationData =
                  notifications[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(notificationData['title']),
                subtitle: Text(notificationData['body']),
                onTap: () {
                  // Handle notification tap
                  handleNotificationTap(context, notificationData);
                },
              );
            },
          );
        },
      ),
    );
  }

  void handleNotificationTap(
      BuildContext context, Map<String, dynamic> notificationData) {
    if (notificationData["type"] == "event") {
      // Get.to(() => EventScreen(event: event))
    }
    // Implement your logic for handling notification tap
    // For example, navigate to a specific screen or perform an action
  }
}
