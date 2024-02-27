import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/controllers/controllers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String topic = 'all_notification';
  if (Platform.isIOS) {
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } else {
      await Future<void>.delayed(
        const Duration(
          seconds: 3,
        ),
      );
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
      }
    }
  } else {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Get.put<AppController>(AppController());
  Get.put<AuthController>(AuthController());

  runApp(const MyApp());
}
