import 'package:flutter/material.dart';
import '../../design_system.dart';

class AppInputEmail extends StatefulWidget {
  final TextEditingController controller;
  final String? errorMessage;
  final bool hasError;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const AppInputEmail({
    super.key,
    required this.controller,
    this.errorMessage,
    this.hasError = false,
    required this.onChanged,
    this.validator,
  });

  @override
  State<AppInputEmail> createState() => _AppInputEmailState();
}

class _AppInputEmailState extends State<AppInputEmail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('E-mail', style: AppFont.labelM12Bold),
        const SizedBox(height: 4),
        TextFormField(
          controller: widget.controller,
          style: AppFont.bodyL16Regular.copyWith(
            color: widget.hasError ? TxtColors.error : TxtColors.primary,
          ),
          decoration: InputDecoration(
            hintText: 'Insira seu e-mail',
            errorStyle: AppFont.labelM12Bold.copyWith(
              color: TxtColors.error,
            ),
            errorText: widget.errorMessage,
            hintStyle: AppFont.bodyL16Regular.copyWith(
              color: widget.hasError ? TxtColors.error : TxtColors.hint,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.stroked),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.focused),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            filled: true,
            fillColor:
                widget.hasError ? AppColors.inputBgError : AppColors.inputBg,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: widget.onChanged,
          validator: widget.validator,
        ),
      ],
    );
  }
}
