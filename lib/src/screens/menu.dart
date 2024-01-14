import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/controllers/controllers.dart';
import 'package:raktadaan/src/models/user_model.dart';
import 'package:raktadaan/src/screens/admin/update_profile.dart';
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
        title: Text('Menu'.tr),
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
        Obx(() {
          final user = AuthController.to.firestoreUser.value;

          if (AuthController.to.isLoggedIn.value && user != null) {
            return _buildMenuItem(Icons.person, 'Update Profile'.tr, () {
              Get.to(() => const UpdateProfileScreen());
            });
          }
          return const SizedBox();
        }),
        _buildMenuItem(Icons.event, 'Events', () {
          // Handle Events
        }),
        _buildMenuItem(Icons.local_hospital, 'Hospitals Contact Details'.tr,
            () {
          // Handle Nearby Hospitals
          Get.to(() => HospitalsListScreen());
        }),
        _buildMenuItem(Icons.settings, 'Settings', () {
          // Handle Settings
        }),
        _buildMenuItem(Icons.language, 'select_language'.tr, () {
          _showLanguageDialog();
        }),
        Obx(() {
          final user = AuthController.to.firestoreUser.value;

          if (AuthController.to.isLoggedIn.value &&
              user != null &&
              user.admin) {
            return _buildMenuItem(Icons.admin_panel_settings, 'Admin', () {
              Get.to(() => const AdminScreen());
            });
          }
          return const SizedBox();
        }),
        Obx(() {
          final user = AuthController.to.firestoreUser.value;
          if (AuthController.to.isLoggedIn.value && user != null) {
            return _buildMenuItem(Icons.logout, 'Logout', () {
              AuthController.to.signOut();
            });
          }
          return const SizedBox();
        })
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('select_language'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageButton('English'.tr, 'en'),
              const SizedBox(height: 10),
              _buildLanguageButton('नेपाली'.tr, 'ne'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageButton(String languageName, String locale) {
    return ElevatedButton(
      onPressed: () {
        Get.find<AppController>().setLocale(locale);
        // Get.updateLocale(Locale(locale));
        Navigator.of(Get.context!).pop();
      },
      child: Text(languageName),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title.tr),
      onTap: onTap,
    );
  }
}
