import 'package:flutter/material.dart';
import 'app_theme.dart';

class CustomTheme {
  static ThemeData get mainTheme {
    return ThemeData(
      primaryColor: AppTheme.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Montserrat',
      appBarTheme: AppBarTheme(
        color: Colors.grey.shade200,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppTheme.headingColor, //change your color here
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppTheme.primaryColor,
      ),
    /*  elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          primary: AppTheme.primaryColor, // background (button) color
        ),
      ),*/
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        buttonColor: AppTheme.primaryColor,
      ),
    );
  }
}
