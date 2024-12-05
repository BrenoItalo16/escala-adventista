import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData? icon;
  final double width;
  final double height;
  final double iconSize;
  final double radious;
  final bool showNotification;

  const AppIconButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
    required this.icon,
    this.width = 48,
    this.height = 48,
    this.iconSize = 24,
    this.radious = 12,
    this.showNotification = false,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radious),
              color: AppColors.selected,
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.grey),
                      ),
                    ),
                  )
                : icon == null
                    ? null
                    : Icon(icon, color: AppColors.grey, size: iconSize),
          ),
          if (!isLoading && showNotification)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(
                    color: AppColors.background,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
