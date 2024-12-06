import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system.dart';

class AppInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? errorMessage;
  final bool hasError;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;

  const AppInput({
    super.key,
    required this.controller,
    required this.label,
    this.errorMessage,
    this.hasError = false,
    required this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.inputFormatters,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppFont.labelM12Bold),
        const SizedBox(height: 4),
        TextFormField(
          controller: widget.controller,
          style: AppFont.bodyL16Regular.copyWith(
            color: widget.hasError ? TxtColors.error : TxtColors.primary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Insira ${widget.label.toLowerCase()}',
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
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
        ),
      ],
    );
  }
}
