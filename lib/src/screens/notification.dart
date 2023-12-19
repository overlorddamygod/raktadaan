// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:raktadaan/src/controllers/controllers.dart';
// import 'package:raktadaan/src/widgets/heplers.dart';
// import 'package:raktadaan/src/widgets/icon_button.dart';

// class NoficationScreen extends StatefulWidget {
//   @override
//   _NoficationScreenState createState() => _NoficationScreenState();
// }

// class _NoficationScreenState extends State<NoficationScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ScrollController _scrollController = ScrollController();
//   List<DocumentSnapshot> _documents = [];
//   bool _isLoading = false;
//   bool _hasMore = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (_hasMore && !_isLoading) {
//           _fetchData();
//         }
//       }
//     });
//   }

//   Future<void> _fetchData() async {
//     if (_hasMore) {
//       setState(() {
//         _isLoading = true;
//       });

//       QuerySnapshot querySnapshot;
//       if (_documents.isEmpty) {
//         querySnapshot = await _firestore
//             .collection('users')
//             .doc()
//             .orderBy('requestAt', descending: true)
//             .limit(10)
//             .get();
//       } else {
//         querySnapshot = await _firestore
//             .collection('user_blood_requests')
//             .orderBy('requestAt', descending: true)
//             .startAfterDocument(_documents.last)
//             .limit(10)
//             .get();
//       }

//       setState(() {
//         _isLoading = false;
//         if (querySnapshot.docs.isNotEmpty) {
//           _documents.addAll(querySnapshot.docs);
//         } else {
//           _hasMore = false;
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Blood Requests'),
//       ),
//       body: ListView.builder(
//         controller: _scrollController,
//         itemCount: _documents.length + (_hasMore ? 1 : 0),
//         itemBuilder: (BuildContext context, int index) {
//           if (index == _documents.length) {
//             if (_hasMore) {
//               return const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text('No more items!'),
//                 ),
//               );
//             }
//             return loader();
//           } else {
//             return _buildListItem(index);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildListItem(int index) {
//     // Replace this with your custom list item widget
//     // return ListTile(
//     //   title: Text(_documents[index]['bloodGroup']),
//     //   subtitle: Text(_documents[index]['bloodGroup']),
//     //   // Add more widgets for additional information
//     // );
//     final bloodRequest = _documents[index];
//     return Card(
//       margin: const EdgeInsets.all(8),
//       child: ListTile(
//         title: Row(
//           children: [
//             Text(bloodRequest['bloodGroup'] + ' Blood Required'),
//             SizedBox(
//               width: 10,
//             ),
//             if (bloodRequest['isUrgent'])
//               const Chip(
//                 label: Text('Urgent'),
//                 backgroundColor: Colors.red,
//                 labelStyle: TextStyle(color: Colors.white),
//               ),
//           ],
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Location: ${bloodRequest['location']}'),
//             // TODO: CallButton
//             callButton(bloodRequest['contactNumber'], "call".tr),
//           ],
//         ),
//       ),
//     );
//   }
// }
