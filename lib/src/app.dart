import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/controllers/app_controller.dart';
import 'package:raktadaan/src/helpers/localization.dart';
import 'package:raktadaan/src/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (controller) => GetMaterialApp(
        translations: Localization(),
        debugShowCheckedModeBanner: false,
        locale: controller.getLocale,
        themeMode: controller.themeMode,
        theme: AppThemes.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
