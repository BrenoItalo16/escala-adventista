import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class AppIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const AppIconButton({
    super.key,
    this.onTap,
    this.isLoading = false,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Stack(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
                : Icon(UIcons.regularRounded.man_head, color: AppColors.grey),
          ),
          if (!isLoading)
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
