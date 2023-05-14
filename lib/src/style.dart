import 'package:flutter/material.dart';

class ThemeStyle {
  static double cardBorderRadious = 10.0;

  static ThemeData lightTheme() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primarySwatch: Colors.orange,
      primaryColor: Colors.orange,
      scaffoldBackgroundColor: Colors.grey.shade50,
      appBarTheme: const AppBarTheme().copyWith(
          elevation: 1,
          titleTextStyle: const TextStyle(
            fontSize: 22.0,
            color: Colors.black87,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData().copyWith(
            color: Colors.white,
          )),
      switchTheme: const SwitchThemeData().copyWith(
        thumbColor:
            MaterialStateProperty.resolveWith<Color>((states) => Colors.white),
        trackColor: MaterialStateProperty.resolveWith<Color>(
            (states) => states.contains(MaterialState.selected)
                ? Colors.orange
                : states.contains(MaterialState.disabled)
                    ? Colors.grey
                    : Colors.black54),
      ),
      tabBarTheme: const TabBarTheme().copyWith(
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black54,
          indicator: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.orange)))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black54),
      // Define the default font family.
      fontFamily: 'Georgia',

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: const TextStyle(color: Colors.orange, fontSize: 14)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(),
          elevation: 0,
          minimumSize: const Size.fromHeight(45.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),

      cardTheme: const CardTheme().copyWith(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardBorderRadious))),

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black87),
        bodySmall: TextStyle(fontSize: 12.0, color: Colors.black87),
        labelLarge: TextStyle(fontSize: 20.0, color: Colors.black),
        labelMedium: TextStyle(fontSize: 15.0, color: Colors.black),
        labelSmall: TextStyle(fontSize: 13.0, color: Colors.black87),
        titleLarge: TextStyle(fontSize: 20.0, color: Colors.black),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
      primaryColor: Colors.orange,
      snackBarTheme: const SnackBarThemeData().copyWith(
        contentTextStyle:
            const TextStyle(fontSize: 14.0, color: Colors.black87),
      ),
      appBarTheme: const AppBarTheme().copyWith(
          centerTitle: true,
          backgroundColor: Colors.grey.shade900,
          titleTextStyle: const TextStyle(
            fontSize: 22.0,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData().copyWith(
            color: Colors.white,
          )),
      switchTheme: const SwitchThemeData().copyWith(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
            (states) => Colors.black12),
        trackColor: MaterialStateProperty.resolveWith<Color>(
            (states) => states.contains(MaterialState.selected)
                ? Colors.orange
                : states.contains(MaterialState.disabled)
                    ? Colors.grey
                    : Colors.white),
      ),

      tabBarTheme: const TabBarTheme().copyWith(
          labelColor: Colors.white70,
          unselectedLabelColor: Colors.white54,
          indicator: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.orange)))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey.shade900,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.white),
      // Define the default font family.
      fontFamily: 'Georgia',

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: const TextStyle(color: Colors.orange, fontSize: 14)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(),
          elevation: 0,
          minimumSize: const Size.fromHeight(45.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),

      cardTheme: const CardTheme().copyWith(
          color: Colors.grey.shade900,
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardBorderRadious))),

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white70),
        bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white70),
        bodySmall: TextStyle(fontSize: 12.0, color: Colors.white70),
        labelLarge: TextStyle(fontSize: 20.0, color: Colors.white),
        labelMedium: TextStyle(fontSize: 15.0, color: Colors.white),
        labelSmall: TextStyle(fontSize: 13.0, color: Colors.white70),
        titleLarge: TextStyle(fontSize: 20.0, color: Colors.white),
      ),
    );
  }
}
