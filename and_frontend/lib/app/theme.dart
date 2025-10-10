import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define our primary color palette
  static const primaryColor = Color(0xFF4A90E2);
  static const secondaryColor = Color(0xFF50E3C2);
  static const backgroundColor = Color(0xFFF4F6F8);
  static const textColor = Color(0xFF333333);
  static const cardColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: cardColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: textColor,
      onSurface: textColor,
      error: Colors.redAccent,
    ),
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textColor),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
        bodyMedium: TextStyle(fontSize: 14, color: textColor),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
    ),
    cardTheme: CardThemeData( // Changed from CardTheme to CardThemeData
      elevation: 4,
      // The shadow color will now be correctly inferred from the theme's colorScheme.
      // This is more compatible across different Flutter versions.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      // This ensures that content inside the card respects the rounded corners.
      clipBehavior: Clip.antiAlias,
    ),
  );
}
