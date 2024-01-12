import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/screens/admin/bloodrequests/view.dart';
import 'package:raktadaan/src/screens/admin/events/view.dart';
import 'package:raktadaan/src/screens/admin/hospitals/view.dart';
import 'package:raktadaan/src/screens/admin/users/view.dart';

class Option {
  final String name;
  final VoidCallback onTap;

  Option(this.name, this.onTap);
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Users"),
            onTap: () {
              Get.to(() => const UsersViewScreen());
            },
          ),
          ListTile(
            title: const Text("Blood Requests"),
            onTap: () {
              Get.to(() => const BloodRequestViewScreen());
            },
          ),
          ListTile(
            title: const Text("Events"),
            onTap: () {
              Get.to(() => const EventsViewScreen());
            },
          ),
          ListTile(
            title: const Text("Hospitals"),
            onTap: () {
              Get.to(() => const HospitalViewScreen());
            },
          ),
        ],
      ),
    );
  }

  Widget buildExpansionTile(String title, List<Option> options) {
    return ExpansionTile(
      title: Text(title),
      children: options.map((option) {
        return ListTile(
          title: Text(option.name),
          onTap: option.onTap,
        );
      }).toList(),
    );
  }
}
