import 'package:flutter/material.dart';
import '../../design_system.dart';

class AppInputPass extends StatefulWidget {
  final TextEditingController controller;
  final String? errorMessage;
  final bool hasError;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const AppInputPass({
    super.key,
    required this.controller,
    this.errorMessage,
    this.hasError = false,
    required this.onChanged,
    this.validator,
  });

  @override
  State<AppInputPass> createState() => _AppInputPassState();
}

class _AppInputPassState extends State<AppInputPass> {
  final _font = AppFont();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Senha', style: _font.labelM12Bold),
        const SizedBox(height: 4),
        TextFormField(
          controller: widget.controller,
          style: _font.bodyL16Regular.copyWith(
            color: widget.hasError ? TxtColors.error : TxtColors.primary,
          ),
          decoration: InputDecoration(
            hintText: 'Insira sua senha',
            errorStyle: _font.labelM12Bold.copyWith(
              color: TxtColors.error,
            ),
            errorText: widget.errorMessage,
            hintStyle: _font.bodyL16Regular.copyWith(
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
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: widget.hasError ? TxtColors.error : TxtColors.hint,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          obscureText: _obscureText,
          onChanged: widget.onChanged,
          validator: widget.validator,
        ),
      ],
    );
  }
}
