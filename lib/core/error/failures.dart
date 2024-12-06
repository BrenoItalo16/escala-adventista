import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Erro de autenticação'])
      : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Erro de cache'])
      : super(message: message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Erro no servidor'])
      : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Erro de conexão'])
      : super(message: message);
}
