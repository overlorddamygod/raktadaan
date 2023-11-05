import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/controllers/controllers.dart';
import 'package:raktadaan/src/screens/menu.dart';
import 'package:raktadaan/src/screens/search_blood.dart';
import 'package:raktadaan/src/screens/sign_in.dart';
import 'package:raktadaan/src/screens/sign_up.dart';
import 'package:raktadaan/src/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  initState() {
    _pages = <Widget>[
      Home(
        onSearchTap: () {
          _onItemTapped(1);
        },
      ),
      const SearchBloodScreen(),
      const Center(
        child: Icon(
          Icons.notifications,
          size: 150,
        ),
      ),
      const Menu(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
    );
  }
}

class Home extends StatelessWidget {
  final VoidCallback onSearchTap;
  const Home({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('raktadaan'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() {
              if (!AuthController.to.isLoggedIn.value) {
                return RButton(
                  buttonTitle: "signin".tr,
                  onPressed: () {
                    Get.to(() => const SignIn());
                  },
                );
              }
              return const SizedBox();
            }),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RHomeIconButton(
                    onTap: () {
                      Get.to(() => const SignUp());
                    },
                    text: "Become\na donor".tr,
                    icon: const Icon(Icons.person_add),
                    color: Colors.green),
                RHomeIconButton(
                  onTap: () {
                    onSearchTap();
                  },
                  text: "search_for_donors_n".tr,
                  icon: const Icon(Icons.search),
                  color: Colors.blue,
                ),
                RHomeIconButton(
                  onTap: () {},
                  text: "Events".tr,
                  icon: const Icon(Icons.event),
                  color: Colors.blue,
                ),
                RHomeIconButton(
                  onTap: () {},
                  text: "Nearby\nHospitals".tr,
                  icon: const Icon(Icons.local_hospital),
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
