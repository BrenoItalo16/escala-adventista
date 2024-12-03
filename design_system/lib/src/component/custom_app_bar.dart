import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:escala_adventista/features/auth/presentation/bloc/auth_bloc.dart';

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
    final font = AppFont();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá', style: font.bodyL16XLight.copyWith(height: 1)),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Text(
                    state.user.name,
                    style: font.headlineS32XBold.copyWith(height: 1),
                  );
                }
                return Text(
                  'Visitante',
                  style: font.headlineS32XBold.copyWith(height: 1),
                );
              },
            ),
          ],
        ),
        const AppIconButton()
      ],
    );
  }
}
