import 'package:escala_adventista/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:escala_adventista/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uicons/uicons.dart';

class CustomAppBar extends StatefulWidget {
  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double elevation;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá', style: AppFont.bodyL16XLight.copyWith(height: 1)),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Text(
                    state.user.name,
                    style: AppFont.headlineS32XBold.copyWith(height: 1),
                  );
                }
                return Text(
                  'Visitante',
                  style: AppFont.headlineS32XBold.copyWith(height: 1),
                );
              },
            ),
          ],
        ),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return AppIconButton(
              icon: UIcons.regularRounded.man_head,
              onTap: isLoading
                  ? null
                  : () async {
                      context.read<AuthBloc>().add(LogoutRequested());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Saindo...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      // Navega para login imediatamente
                      context.go(AppRoutes.login);
                    },
              isLoading: isLoading,
            );
          },
        )
      ],
    );
  }
}
