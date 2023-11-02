//User Model
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
      };

  static final defaultUser = UserModel.fromMap({});
}
