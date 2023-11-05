import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/models/user_model.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  final firestoreUser = Rxn<UserModel?>();

  // ignore: unnecessary_null_comparison
  RxBool get isLoggedIn => RxBool(_auth.currentUser != null);

  @override
  void onInit() {
    print("INITITTT");
    _auth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        print('User is currently signed out!');
        return;
      }
      print("CHANGE");
      getFirestoreUser();
    });

    super.onInit();
  }

  void getFirestoreUser() async {
    print("GETTING");
    print(currentUser!.uid);

    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUser!.uid)
        .get();

    if (user.docs.isNotEmpty) {
      firestoreUser.value = UserModel.fromMap(user.docs[0].data());
      print(firestoreUser.value!.firstName);
    }
  }

  void signOut() {
    _auth.signOut();
    Get.showSnackbar(const GetSnackBar(
      title: "Signed out successfully",
      message: " ",
      duration: Duration(seconds: 2),
    ));

    firestoreUser.value = null;

    Get.offAllNamed('/');
  }
}
