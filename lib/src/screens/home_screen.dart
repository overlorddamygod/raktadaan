import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/controllers/app_controller.dart';
import 'package:raktadaan/src/controllers/controllers.dart';
import 'package:raktadaan/src/screens/menu.dart';
import 'package:raktadaan/src/screens/sign_in.dart';
import 'package:raktadaan/src/screens/sign_up.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    Home(),
    Center(
      child: Icon(
        Icons.search,
        size: 150,
      ),
    ),
    Center(
      child: Icon(
        Icons.notifications,
        size: 150,
      ),
    ),
    Menu(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Home'),
        // ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
            // BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          ],
        ));
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('signin'.tr),
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            Get.to(const SignUp());
          },
          child: const Text('Become A Doner'),
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            Get.to(const SignIn());
          },
          child: const Text('Sign In'),
        ),
        TextButton(
          onPressed: () {
            final controller = Get.find<AppController>();

            // controller.setLocale('en');
          },
          child: const Text('Language'),
        ),
        TextButton(
          onPressed: () async {
            final currentAddress = await GeoCode()
                .reverseGeocoding(latitude: 27.66324, longitude: 85.32315);
            print(currentAddress.toString());
            await placemarkFromCoordinates(27.66324, 85.32315)
                .then((List<Placemark> placemarks) {
              print(placemarks.length);
              Placemark place = placemarks[0];
              // place.administrativeArea
              print(
                  '${place.locality} ${place.street}, ${place.subLocality},${place.administrativeArea}, ${place.postalCode} ${place.country} ${place.postalCode}');
            }).catchError((e) {
              debugPrint(e);
            });
          },
          child: const Text('Location'),
        ),
        TextButton(
          onPressed: () {
            AuthController.to.signOut();
            // controller.setLocale('en');
          },
          child: const Text('SignOut'),
        ),
        if (AuthController.to.isLoggedIn.value)
          Text(AuthController.to.currentUser!.email.toString())
      ],
    );
  }
}
