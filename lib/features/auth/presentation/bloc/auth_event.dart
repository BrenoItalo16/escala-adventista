part of 'auth_bloc.dart';

abstract class AuthEvent extends BaseEvent {
  const AuthEvent();
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignupSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignupSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class LogoutRequested extends AuthEvent {}

class AuthenticationStatusRequested extends AuthEvent {}
