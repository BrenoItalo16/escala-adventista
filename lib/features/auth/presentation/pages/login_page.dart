import 'package:design_system/design_system.dart';
import 'package:escala_adventista/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:escala_adventista/core/services/storage_service.dart';
import 'package:get_it/get_it.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hasEmailError = false;
  String? _emailErrorMessage;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
              .hasMatch(_emailController.text);
    });
  }

  void _updateEmailError(String? value) {
    final isValid = value != null &&
        value.isNotEmpty &&
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value);
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

  @override
  Widget build(BuildContext context) {
    final font = AppFont();
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            debugPrint('Auth Error Message: ${state.message}');
            setState(() {
              _hasEmailError = true;
              _emailErrorMessage = 'Este e-mail ainda não foi cadastrado';
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
                content: Text('Login efetuado com sucesso'),
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
                    'Bem-vindo de volta!',
                    style: font.titleM24XLight,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 128,
                    height: 157,
                    child: AppLogo(),
                  ),
                  const SizedBox(height: 48),
                  AppInputEmail(
                    controller: _emailController,
                    errorMessage: _emailErrorMessage,
                    hasError: _hasEmailError,
                    onChanged: _updateEmailError,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      final emailRegex = RegExp(
                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  AppInputPass(
                    controller: _passwordController,
                    hasError: false,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          AppButton(
                            onPressed: state is AuthLoading || !_isFormValid
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _hasEmailError = false;
                                        _emailErrorMessage = null;
                                      });
                                      context.read<AuthBloc>().add(
                                            LoginSubmitted(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            ),
                                          );
                                    }
                                  },
                            text: 'Entrar',
                            isLoading: state is AuthLoading,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              context.push(AppRoutes.signup);
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Não possui uma conta? ',
                                    style: font.bodyL16Regular.copyWith(
                                      color: TxtColors.hint,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Cadastre-se',
                                    style: font.bodyL16Regular.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
