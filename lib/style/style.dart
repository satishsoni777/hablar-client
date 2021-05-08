import 'package:flutter/material.dart';

class Themes {

  static ThemeData appThemeLight() {
    return ThemeData(
      brightness: Brightness.light,

      appBarTheme: AppBarTheme(
        color: Colors.white
      )
    );
  }
}