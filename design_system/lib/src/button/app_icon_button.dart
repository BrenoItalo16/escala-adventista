import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:escala_adventista/features/auth/presentation/bloc/auth_bloc.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key});

  //TODO: boleano para notificação

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AuthBloc>().add(
              AuthenticationStatusRequested(),
            );
      },
      child: Stack(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.selected,
            ),
            child: Icon(UIcons.regularRounded.man_head, color: AppColors.grey),
          ),
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
