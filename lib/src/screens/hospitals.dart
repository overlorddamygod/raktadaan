import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/helpers/helpers.dart';

class HospitalsListScreen extends StatelessWidget {
  const HospitalsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitals List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('hospitals').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var hospitals = snapshot.data!.docs;

          return ListView.builder(
            itemCount: hospitals.length,
            itemBuilder: (context, index) {
              var hospitalData = hospitals[index].data();

              return ListTile(
                title: Text(hospitalData['name']),
                subtitle: Text(hospitalData['address']),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    call(hospitalData["contact"]);
                  },
                  child: Text('Call'.tr),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
