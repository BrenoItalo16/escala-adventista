import 'package:design_system/src/theme/app_colors.dart';
import 'package:design_system/src/theme/txt_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.primary,
        size: 30,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.white,
    ),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.nunito(
        fontWeight: FontWeight.w400,
        color: TxtColors.primary,
      ),
    ),
  );
}
