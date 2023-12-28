import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static const Color primaryColor = Color(0xFF9E3220);
  //the light theme
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: const MaterialColor(
      0xFFF46D75,
      <int, Color>{
        50: primaryColor,
        100: primaryColor,
        200: primaryColor,
        300: primaryColor,
        400: primaryColor,
        500: primaryColor,
        600: primaryColor,
        700: primaryColor,
        800: primaryColor,
        900: primaryColor,
      },
    ),
    appBarTheme: const AppBarTheme(
        // color: _lightBackgroundAppBarColor,
        // iconTheme: IconThemeData(color: _lightTextColor),
        // textTheme: _lightTextTheme,
        ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      // : _lightBackgroundColor,
      // secondary: _lightSecondaryColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );

//text theme for dark theme
  /*static final TextStyle _darkScreenHeadingTextStyle =
      _lightScreenHeadingTextStyle.copyWith(color: _darkTextColor);
  static final TextStyle _darkScreenTaskNameTextStyle =
      _lightScreenTaskNameTextStyle.copyWith(color: _darkTextColor);
  static final TextStyle _darkScreenTaskDurationTextStyle =
      _lightScreenTaskDurationTextStyle;
  static final TextStyle _darkScreenButtonTextStyle = TextStyle(
      fontSize: 14.0, color: _darkTextColor, fontWeight: FontWeight.w500);
  static final TextStyle _darkScreenCaptionTextStyle = TextStyle(
      fontSize: 12.0,
      color: _darkBackgroundAppBarColor,
      fontWeight: FontWeight.w100);*/
}
