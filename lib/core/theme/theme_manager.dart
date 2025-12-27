import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900],
    primaryColor: Colors.pink,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[600],
      foregroundColor: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.pink),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.pink,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.pink[200],
      foregroundColor: Colors.black,
    ),
    iconTheme: IconThemeData(color: Colors.pink),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );
}