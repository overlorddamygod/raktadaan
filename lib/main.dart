import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/controllers/controllers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put<AppController>(AppController());
  Get.put<AuthController>(AuthController());

  runApp(const MyApp());
}
