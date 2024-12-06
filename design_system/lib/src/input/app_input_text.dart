import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system.dart';

enum InputType { text, address, city, state, number, neighborhood }

class AppInputText extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? errorMessage;
  final bool hasError;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final String? hintText;
  final InputType type;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const AppInputText({
    super.key,
    required this.controller,
    required this.label,
    this.errorMessage,
    this.hasError = false,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.type = InputType.text,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  State<AppInputText> createState() => _AppInputTextState();
}

class _AppInputTextState extends State<AppInputText> {
  final List<String> _brazilianStates = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  String? _getDefaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }

    switch (widget.type) {
      case InputType.address:
        if (value.length < 5) {
          return 'Endereço muito curto';
        }
        break;
      case InputType.city:
        if (value.length < 3) {
          return 'Nome da cidade muito curto';
        }
        if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value)) {
          return 'Nome da cidade inválido';
        }
        break;
      case InputType.state:
        if (!_brazilianStates.contains(value.toUpperCase())) {
          return 'Estado inválido';
        }
        break;
      case InputType.number:
        if (!RegExp(r'^\d+$').hasMatch(value)) {
          return 'Insira apenas números';
        }
        break;
      default:
        break;
    }

    return null;
  }

  String? _validateInput(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    return _getDefaultValidator(value);
  }

  TextInputType _getKeyboardType() {
    if (widget.keyboardType != null) {
      return widget.keyboardType!;
    }

    switch (widget.type) {
      case InputType.number:
        return TextInputType.number;
      case InputType.address:
        return TextInputType.streetAddress;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (widget.inputFormatters != null) {
      return widget.inputFormatters;
    }

    switch (widget.type) {
      case InputType.state:
        return [
          LengthLimitingTextInputFormatter(2),
          UpperCaseTextFormatter(),
        ];
      case InputType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  String _getHintText() {
    if (widget.hintText != null) return widget.hintText!;

    switch (widget.type) {
      case InputType.address:
        return 'Ex: Rua das Flores';
      case InputType.city:
        return 'Ex: São Paulo';
      case InputType.state:
        return 'Ex: SP';
      case InputType.number:
        return 'Ex: 123';
      case InputType.neighborhood:
        return 'Ex: Centro';
      default:
        return 'Digite aqui';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppInput(
      controller: widget.controller,
      label: widget.label,
      errorMessage: widget.errorMessage,
      hasError: widget.hasError,
      onChanged: (value) {
        if (widget.type == InputType.state && value != null) {
          final upperValue = value.toUpperCase();
          widget.controller.value = widget.controller.value.copyWith(
            text: upperValue,
            selection: TextSelection.collapsed(offset: upperValue.length),
          );
        }
        widget.onChanged(value);
      },
      validator: _validateInput,
      keyboardType: _getKeyboardType(),
      inputFormatters: _getInputFormatters(),
      hintText: _getHintText(),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
