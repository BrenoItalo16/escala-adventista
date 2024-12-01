import 'package:flutter/material.dart';

import '../../design_system.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImage.logoWithText,
      package: AppSvg.packageName,
      width: 100,
      height: 100,
    );
  }
}
