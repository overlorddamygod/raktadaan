import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String photoUrl;
  String firstName;
  String middleName;
  String lastName;
  String mobileNumber = '';
  String bloodGroup = '';
  String citizenshipNo = '';
  bool verified;
  bool donor;
  UserPosition? position;
  bool admin;
  String? documentUrl = '';
  String? disease = '';
  DateTime dob = DateTime.now();
  DateTime? dateOfLastTransfusion;

  UserModel({
    required this.uid,
    required this.email,
    required this.photoUrl,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.mobileNumber,
    required this.bloodGroup,
    required this.citizenshipNo,
    required this.verified,
    required this.donor,
    this.position,
    this.documentUrl,
    this.disease,
    required this.dob,
    this.dateOfLastTransfusion,
    required this.admin,
  });

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      firstName: data['firstName'] ?? '',
      middleName: data['middleName'] ?? '',
      lastName: data['lastName'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      bloodGroup: data['bloodGroup'] ?? '',
      citizenshipNo: data['citizenshipNo'] ?? '',
      verified: data['verified'] ?? false,
      donor: data['donor'] ?? false,
      admin: data['admin'] ?? false,
      position: data['position'] != null
          ? UserPosition.fromMap(data['position'])
          : null,
      documentUrl: data['documentUrl'] ?? '',
      disease: data['disease'] ?? '',
      dob: data['dob'] != null ? data['dob'].toDate() : DateTime.now(),
      dateOfLastTransfusion: data['dateOfLastTransfusion'] != null
          ? data['dateOfLastTransfusion'].toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'mobileNumber': mobileNumber,
        'bloodGroup': bloodGroup,
        'citizenshipNo': citizenshipNo,
        'donor': donor,
        'admin': admin,
        'verified': verified,
        'position': position != null
            ? {
                'geohash': position!.geohash,
                'geopoint': position!.geopoint,
              }
            : null,
        'documentUrl': documentUrl,
        'disease': disease,
        'dob': dob,
        'dateOfLastTransfusion': dateOfLastTransfusion,
      };

  static final defaultUser = UserModel.fromMap({});

  String get fullName {
    if (middleName == null || middleName == '') {
      return '$firstName $lastName';
    }
    return '$firstName $middleName $lastName';
  }

  int get age {
    var today = DateTime.now();
    var birthDate = dob;
    var age = today.year - birthDate.year;
    var month1 = today.month;
    var month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      var day1 = today.day;
      var day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  String get lastTransfusion {
    if (dateOfLastTransfusion == null) {
      return 'Never';
    }
    // return days ago
    var diff = DateTime.now().difference(dateOfLastTransfusion!);
    return '${diff.inDays} days ago';
  }
}

class UserPosition {
  String geohash;
  GeoPoint geopoint;

  UserPosition({required this.geohash, required this.geopoint});

  factory UserPosition.fromMap(Map data) {
    return UserPosition(
      geohash: data['geohash'] ?? '',
      geopoint: data['geopoint'] ?? GeoPoint(0, 0),
    );
  }
}
