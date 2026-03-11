import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // BAGIC Brand Colors
  static const Color bagicBlue = Color(0xFF00529B);
  static const Color bagicWhite = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: bagicBlue,
      primary: bagicBlue,
      onPrimary: bagicWhite,
      surface: bagicWhite,
      onSurface: Colors.black87,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Light greyish blue for better bento contrast
    appBarTheme: const AppBarTheme(
      backgroundColor: bagicWhite,
      foregroundColor: bagicBlue,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: GoogleFonts.lexendTextTheme(ThemeData.light().textTheme),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: bagicBlue,
      primary: bagicBlue,
      onPrimary: bagicWhite,
      surface: darkSurface,
      onSurface: bagicWhite,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: bagicWhite,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: GoogleFonts.lexendTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: bagicWhite,
      displayColor: bagicWhite,
    ),
  );
}
