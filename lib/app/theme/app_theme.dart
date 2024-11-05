import "package:flutter/material.dart";

final appTheme = AppTheme();

ThemeData themeData = ThemeData(
  primaryColor: appTheme.primaryColor,
  scaffoldBackgroundColor: appTheme.bgColor,
  colorScheme: const ColorScheme.light().copyWith(
    primary: appTheme.primaryColor,
    error: Colors.red,
    onPrimary: appTheme.primaryColor,
    onSecondary: appTheme.secondaryColor,
    onSurface: Colors.white,
    onError: Colors.red,
    brightness: Brightness.dark,
    secondary: appTheme.secondaryColor,
    secondaryContainer: appTheme.secondaryColor,
    surface: Colors.white,
  ),
);

class AppTheme {
  // Colors
  Color primaryColor = const Color(0xffff6600);
  Color secondaryColor = const Color(0xffef1443);
  Color bgColor = const Color(0xffffffff);
  Color txtError = Colors.red;
  Color txtColor = const Color(0xff222222);
  Color txtLinkColor = const Color(0xff00a3ff);
  Color txtSupportColor = const Color(0xff939aa5);
  Color txtHintColor = const Color(0xffc7c7c7);
  Color txtWhiteColor = const Color(0xffffffff);
  // Body Small
  late final bodyS12Bold = TextStyle(
    fontSize: 12,
    color: txtColor,
    fontWeight: FontWeight.w700,
  );

  late final bodyS12Medium = TextStyle(
    fontSize: 12,
    color: txtColor,
    fontWeight: FontWeight.w500,
  );

  late final bodyS12Regular = TextStyle(
    fontSize: 12,
    color: txtColor,
    fontWeight: FontWeight.w400,
  );

  late final bodyS12XLight = TextStyle(
    fontSize: 12,
    color: txtColor,
    fontWeight: FontWeight.w200,
  );

  // Body Medium
  late final bodyM14Bold = TextStyle(
    fontSize: 14,
    color: txtColor,
    fontWeight: FontWeight.w700,
  );

  late final bodyM14Medium = TextStyle(
    fontSize: 14,
    color: txtColor,
    fontWeight: FontWeight.w500,
  );

  late final bodyM14Regular = TextStyle(
    fontSize: 14,
    color: txtColor,
    fontWeight: FontWeight.w400,
  );

  late final bodyM14XLight = TextStyle(
    fontSize: 14,
    color: txtColor,
    fontWeight: FontWeight.w200,
  );

  // Body Large
  late final bodyL16Bold = TextStyle(
    fontSize: 16,
    color: txtColor,
    fontWeight: FontWeight.w700,
  );

  late final bodyL16Medium = TextStyle(
    fontSize: 16,
    color: txtColor,
    fontWeight: FontWeight.w500,
  );

  late final bodyL16Regular = TextStyle(
    fontSize: 16,
    color: txtColor,
    fontWeight: FontWeight.w400,
  );

  late final bodyL16XLight = TextStyle(
    fontSize: 16,
    color: txtColor,
    fontWeight: FontWeight.w200,
  );

  // Body
}
