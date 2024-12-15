import 'package:design_system/src/theme/app_colors.dart';
import 'package:design_system/src/theme/txt_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final theme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primary,
    primaryColorDark: AppColors.primary,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.primary,
        size: 30,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.primary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      error: AppColors.error,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.black,
      onError: AppColors.white,
      brightness: Brightness.light,
    ),
    // Progress Indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      circularTrackColor: AppColors.stroked,
      linearTrackColor: AppColors.stroked,
      refreshBackgroundColor: AppColors.stroked,
    ),

    // Text Selection Theme
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBg,
      errorStyle: const TextStyle(color: AppColors.error),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.stroked),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.stroked),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.grey,
        disabledBackgroundColor: AppColors.disabled,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.primary,
    ),

    // Drawer Theme
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.white,
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: GoogleFonts.nunito(color: TxtColors.primary),
      displayMedium: GoogleFonts.nunito(color: TxtColors.primary),
      displaySmall: GoogleFonts.nunito(color: TxtColors.primary),
      headlineLarge: GoogleFonts.nunito(color: TxtColors.primary),
      headlineMedium: GoogleFonts.nunito(color: TxtColors.primary),
      headlineSmall: GoogleFonts.nunito(color: TxtColors.primary),
      titleLarge: GoogleFonts.nunito(color: TxtColors.primary),
      titleMedium: GoogleFonts.nunito(color: TxtColors.primary),
      titleSmall: GoogleFonts.nunito(color: TxtColors.primary),
      bodyLarge: GoogleFonts.nunito(color: TxtColors.primary),
      bodyMedium: GoogleFonts.nunito(color: TxtColors.primary),
      bodySmall: GoogleFonts.nunito(color: TxtColors.primary),
      labelLarge: GoogleFonts.nunito(
        fontWeight: FontWeight.w400,
        color: TxtColors.primary,
      ),
      labelMedium: GoogleFonts.nunito(color: TxtColors.primary),
      labelSmall: GoogleFonts.nunito(color: TxtColors.primary),
    ),
  );
}
