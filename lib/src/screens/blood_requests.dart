import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/screens/new_blood_request_screen.dart';
import 'package:raktadaan/src/widgets/helpers.dart';
import 'package:raktadaan/src/widgets/icon_button.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  _BloodRequestScreenState createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _documents = [];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_hasMore && !_isLoading) {
          _fetchData();
        }
      }
    });
  }

  Future<void> _fetchData() async {
    if (_hasMore) {
      setState(() {
        _isLoading = true;
      });

      QuerySnapshot querySnapshot;
      if (_documents.isEmpty) {
        querySnapshot = await _firestore
            .collection('user_blood_requests')
            .orderBy('requestAt', descending: true)
            .limit(10)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection('user_blood_requests')
            .orderBy('requestAt', descending: true)
            .startAfterDocument(_documents.last)
            .limit(10)
            .get();
      }

      setState(() {
        _isLoading = false;
        if (querySnapshot.docs.isNotEmpty) {
          _documents.addAll(querySnapshot.docs);
        } else {
          _hasMore = false;
        }
      });
    }
  }

  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 2));
    // print("refreshing");
    // // Clear existing data before fetching new data
    // setState(() {
    //   _documents.clear();
    //   _hasMore = true;
    // });
    // await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Requests'),
      ),
      // New request button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const NewBloodRequestScreen());
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _documents.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No requests for now!'),
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: _documents.length + (_hasMore ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == _documents.length) {
                    if (_hasMore) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No more items!'),
                        ),
                      );
                    }
                    return loader();
                  } else {
                    return _buildListItem(index);
                  }
                },
              ),
      ),
    );
  }

  Widget _buildListItem(int index) {
    // Replace this with your custom list item widget
    // return ListTile(
    //   title: Text(_documents[index]['bloodGroup']),
    //   subtitle: Text(_documents[index]['bloodGroup']),
    //   // Add more widgets for additional information
    // );
    final bloodRequest = _documents[index];
    return Card(
      // margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Row(
          children: [
            Text(bloodRequest['bloodGroup'] + ' Blood Required'),
            SizedBox(
              width: 10,
            ),
            if (bloodRequest['isUrgent'])
              const Chip(
                label: Text('Urgent'),
                backgroundColor: Colors.red,
                labelStyle: TextStyle(color: Colors.white),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${bloodRequest['location']}'),
            // TODO: CallButton
            const SizedBox(
              height: 5,
            ),
            callButton(bloodRequest['contactNumber'], "call".tr),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
