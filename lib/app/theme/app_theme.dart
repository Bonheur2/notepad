import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
    );
  }

  static ThemeData get highContrastLight {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
        contrastLevel: 1.0,
      ),
    );
  }

  static ThemeData get highContrastDark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
        contrastLevel: 1.0,
      ),
    );
  }
}
