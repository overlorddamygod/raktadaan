import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/controllers/controllers.dart';
import 'package:raktadaan/src/models/event_model.dart';
import 'package:raktadaan/src/screens/blood_requests.dart';
import 'package:raktadaan/src/screens/event_screen.dart';
import 'package:raktadaan/src/screens/menu.dart';
import 'package:raktadaan/src/screens/search_blood.dart';
import 'package:raktadaan/src/screens/search_map.dart';
import 'package:raktadaan/src/screens/sign_in.dart';
import 'package:raktadaan/src/screens/sign_up.dart';

import '../widgets/widgets.dart';

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
    if (index == 2) {
      // open drawer
      Get.bottomSheet(
        ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search by location'),
              onTap: () {
                Get.back();
                Get.to(() => const SearchMapScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search by blood group'),
              onTap: () {
                Get.back();
                Get.to(() => const SearchBloodScreen());
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  initState() {
    _pages = <Widget>[
      Home(
        onSearchTap: () {
          _onItemTapped(1);
        },
      ),
      BloodRequestScreen(),
      const SizedBox(),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Blood Requests'),
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

class Home extends StatefulWidget {
  final VoidCallback onSearchTap;
  const Home({super.key, required this.onSearchTap});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<EventModel> events = [];

  @override
  initState() {
    super.initState();
    getEvents();
  }

  getEvents() async {
    print("SADD");
    var querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .orderBy("date")
        .limit(10)
        .get();
    events.addAll(querySnapshot.docs.map((doc) {
      // Assuming there's a factory constructor in EventModel
      return EventModel.fromMap(doc.data() as Map<String, dynamic>);
    }));

    print(events[0]);
  }

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
                    widget.onSearchTap();
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
            const SizedBox(
              height: 10,
            ),
            // events sections.. horizontal scroll events with image and title
            // align text to left and the card height of 200 or so
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Events'.tr,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 230,
              child: ListView.builder(
                itemCount: events.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var event = events[index];
                  return Container(
                    width: 200,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => EventScreen(event: event));
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Image.network(
                              event.image,
                              height: 150,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    event.description,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
