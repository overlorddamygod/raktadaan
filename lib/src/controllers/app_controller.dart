import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  RxString locale = 'en'.obs;
  RxString theme = 'light'.obs;

  ThemeMode get themeMode =>
      theme.value == 'light' ? ThemeMode.light : ThemeMode.dark;

  Locale get getLocale => Locale(locale.value);

  @override
  void onInit() {
    loadSettings();
    super.onInit();
  }

  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('locale')) {
      locale.value = prefs.getString('locale') ?? 'en';
    }

    if (prefs.containsKey('theme')) {
      theme.value = prefs.getString('theme') ?? 'light';
    }
  }

  void setLocale(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', value);
    locale.value = value;
    Get.updateLocale(getLocale);
  }

  void setTheme(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', value);
    theme.value = value;
    // Get.
  }
}
