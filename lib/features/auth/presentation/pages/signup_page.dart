import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:escala_adventista/core/services/storage_service.dart';
import '../bloc/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _hasEmailError = false;
  String? _emailErrorMessage;
  bool _isFormValid = false;

  static final _emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  static final _passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword([String? _]) {
    final value = _passwordController.text;
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
      _hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
      _hasNumber = RegExp(r'[0-9]').hasMatch(value);
      _hasSpecialChar = RegExp(r'[@$!%*?&]').hasMatch(value);
    });
    _validateForm();
  }

  void _validateForm() {
    setState(() {
      final isPasswordValid = _passwordController.text.isNotEmpty &&
          _validatePasswordField(_passwordController.text) == null;

      _isFormValid = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          isPasswordValid &&
          _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text &&
          _emailRegex.hasMatch(_emailController.text);
    });
  }

  void _updateEmailError(String? value) {
    final isValid =
        value != null && value.isNotEmpty && _emailRegex.hasMatch(value);
    setState(() {
      _hasEmailError = !isValid;
      if (!isValid) {
        if (value == null || value.isEmpty) {
          _emailErrorMessage = 'Por favor, insira seu email';
        } else {
          _emailErrorMessage = 'Por favor, insira um email válido';
        }
      } else {
        _emailErrorMessage = null;
      }
    });
  }

  Widget _buildPasswordHelper() {
    final font = AppFont();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'A senha deve conter:',
          style: font.labelM12Regular.copyWith(color: TxtColors.hint),
        ),
        const SizedBox(height: 8),
        _buildPasswordRequirement(
          'Pelo menos 8 caracteres',
          _hasMinLength,
        ),
        _buildPasswordRequirement(
          'Pelo menos uma letra maiúscula',
          _hasUpperCase,
        ),
        _buildPasswordRequirement(
          'Pelo menos uma letra minúscula',
          _hasLowerCase,
        ),
        _buildPasswordRequirement(
          'Pelo menos um número',
          _hasNumber,
        ),
        _buildPasswordRequirement(
          'Pelo menos um caractere especial (@\$!%*?&)',
          _hasSpecialChar,
        ),
      ],
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    final font = AppFont();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? Colors.green : TxtColors.hint,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: font.labelM12Regular.copyWith(
              color: isMet ? Colors.green : TxtColors.hint,
            ),
          ),
        ],
      ),
    );
  }

  String? _validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    if (!_passwordRegex.hasMatch(value)) {
      return 'A senha não atende aos requisitos mínimos';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final font = AppFont();
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            setState(() {
              _hasEmailError = true;
              _emailErrorMessage = state.message;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            setState(() {
              _hasEmailError = false;
              _emailErrorMessage = null;
            });
            GetIt.I<StorageService>().setAuthState(true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Conta criada com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/home');
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Criar Conta',
                    style: font.titleM24XLight,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 128,
                    height: 157,
                    child: AppLogo(),
                  ),
                  const SizedBox(height: 48),
                  AppInput(
                    controller: _nameController,
                    label: 'Nome',
                    hasError: false,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  AppInputEmail(
                    controller: _emailController,
                    errorMessage: _emailErrorMessage,
                    hasError: _hasEmailError,
                    onChanged: _updateEmailError,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      if (!_emailRegex.hasMatch(value)) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  AppInputPass(
                    controller: _passwordController,
                    hasError: false,
                    onChanged: _validatePassword,
                    validator: _validatePasswordField,
                  ),
                  _buildPasswordHelper(),
                  const SizedBox(height: 24),
                  AppInputPass(
                    controller: _confirmPasswordController,
                    label: 'Confirmar senha',
                    hasError: false,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme sua senha';
                      }
                      if (value != _passwordController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        text: 'Criar Conta',
                        isLoading: state is AuthLoading,
                        onPressed: _isFormValid
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _hasEmailError = false;
                                    _emailErrorMessage = null;
                                  });
                                  context.read<AuthBloc>().add(
                                        SignupSubmitted(
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                }
                              }
                            : null,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Já tem uma conta? ',
                            style: font.bodyL16Regular.copyWith(
                              color: TxtColors.hint,
                            ),
                          ),
                          TextSpan(
                            text: 'Entrar',
                            style: font.bodyL16Regular
                                .copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
