import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/screens/admin/bloodrequests/view.dart';
import 'package:raktadaan/src/screens/admin/events/create.dart';
import 'package:raktadaan/src/screens/admin/events/view.dart';
import 'package:raktadaan/src/screens/admin/hospitals/view.dart';

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
          buildExpansionTile('Users', [
            Option('Insert', () {
              // Handle insert tap for Users
            }),
            Option('Update', () {
              // Handle update tap for Users
            }),
            Option('Delete', () {
              // Handle delete tap for Users
            }),
          ]),
          ListTile(
            title: const Text("Blood Requests"),
            onTap: () {
              Get.to(() => BloodRequestViewScreen());
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
