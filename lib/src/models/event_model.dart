//User Model
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String uid;
  String title;
  String description;
  Timestamp date;
  String image;

  EventModel({
    required this.uid,
    required this.title,
    required this.description,
    required this.date,
    required this.image,
  });

  factory EventModel.fromMap(Map data) {
    return EventModel(
      uid: data['uid'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      image: data['image'] ??
          'https://www.shutterstock.com/image-vector/blood-bag-donated-cute-cartoon-600nw-2293990295.jpg',
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'title': title,
        'description': description,
        'date': date,
        'image': image,
      };
}
