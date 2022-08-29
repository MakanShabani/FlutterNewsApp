import 'package:flutter/material.dart';

class ThemeStyle {
  static ThemeData lightTheme() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primarySwatch: Colors.orange,
      primaryColor: Colors.orange,
      appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData().copyWith(
            color: Colors.orange,
          )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black54),
      // Define the default font family.
      fontFamily: 'Georgia',

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.orange,
          elevation: 0,
          minimumSize: const Size.fromHeight(45.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0),
          bodyText1: TextStyle(fontSize: 14.0),
          button: TextStyle(fontSize: 14.0, color: Colors.black54)),
    );
  }
}
