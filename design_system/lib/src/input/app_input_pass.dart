import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';
import '../../design_system.dart';

class AppInputPass extends StatefulWidget {
  final TextEditingController controller;
  final String? errorMessage;
  final bool hasError;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final String label;
  final String? helperText;

  const AppInputPass({
    super.key,
    required this.controller,
    this.errorMessage,
    this.hasError = false,
    required this.onChanged,
    this.validator,
    this.label = 'Senha',
    this.helperText,
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
        Text(widget.label, style: _font.labelM12Bold),
        const SizedBox(height: 4),
        TextFormField(
          controller: widget.controller,
          style: _font.bodyL16Regular.copyWith(
            color: widget.hasError ? TxtColors.error : TxtColors.primary,
          ),
          decoration: InputDecoration(
            hintText: 'Insira sua ${widget.label.toLowerCase()}',
            errorStyle: _font.labelM12Bold.copyWith(
              color: TxtColors.error,
            ),
            errorText: widget.errorMessage,
            helperText: widget.helperText,
            helperStyle: _font.labelM12Regular.copyWith(
              color: TxtColors.hint,
            ),
            helperMaxLines: 10,
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
                _obscureText
                    ? UIcons.regularRounded.eye_crossed
                    : UIcons.regularRounded.eye,
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
