import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static const Color primaryColor = Color(0xFFF46D75);

  //the light theme
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: MaterialColor(
      0xFFF46D75,
      <int, Color>{
        50: Color(0xFFF46D75),
        100: Color(0xFFF46D75),
        200: Color(0xFFF46D75),
        300: Color(0xFFF46D75),
        400: Color(0xFFF46D75),
        500: Color(0xFFF46D75),
        600: Color(0xFFF46D75),
        700: Color(0xFFF46D75),
        800: Color(0xFFF46D75),
        900: Color(0xFFF46D75),
      },
    ),
    appBarTheme: AppBarTheme(
        // color: _lightBackgroundAppBarColor,
        // iconTheme: IconThemeData(color: _lightTextColor),
        // textTheme: _lightTextTheme,
        ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      // : _lightBackgroundColor,
      // secondary: _lightSecondaryColor,
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
