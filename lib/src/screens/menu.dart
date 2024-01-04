import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/controllers/controllers.dart';
import 'package:raktadaan/src/models/user_model.dart';
import 'package:raktadaan/src/screens/admin_screen.dart';
import 'package:raktadaan/src/screens/hospitals.dart';
import 'package:raktadaan/src/widgets/verified.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final user = AuthController.to.firestoreUser.value;
    print("MENUUU");
    // print(AuthController.to.isLoggedIn.value);
    // print(user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() {
              final user = AuthController.to.firestoreUser.value;

              if (AuthController.to.isLoggedIn.value && user != null) {
                return _buildUserDetails(user);
              }
              return const SizedBox();
            }),
            _buildMenuList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetails(UserModel user) {
    print("MENUUU11111");
    print(user.email);
    return Row(
      children: [
        const Icon(Icons.person, size: 60),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.firstName} ${user.middleName} ${user.lastName}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(user.email,
                  style: const TextStyle(fontWeight: FontWeight.w300)),
              Verified(verified: user.verified),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList() {
    return Column(
      children: [
        _buildMenuItem(Icons.person, 'Profile', () {
          // Handle Profile
        }),
        _buildMenuItem(Icons.event, 'Events', () {
          // Handle Events
        }),
        _buildMenuItem(Icons.local_hospital, 'Hospitals Contact Details', () {
          // Handle Nearby Hospitals
          Get.to(() => HospitalsListScreen());
        }),
        _buildMenuItem(Icons.settings, 'Settings', () {
          // Handle Settings
        }),
        _buildMenuItem(Icons.admin_panel_settings, 'Admin', () {
          Get.to(() => const AdminScreen());
        }),
        Obx(() {
          final user = AuthController.to.firestoreUser.value;

          if (AuthController.to.isLoggedIn.value && user != null) {
            return _buildMenuItem(Icons.logout, 'Logout', () {
              AuthController.to.signOut();
            });
          }
          return const SizedBox();
        }),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
