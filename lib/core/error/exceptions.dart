class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class ServerException extends AppException {
  ServerException([super.message = 'Erro no servidor']);
}

class CacheException extends AppException {
  CacheException([super.message = 'Erro no cache']);
}

class NetworkException extends AppException {
  NetworkException([super.message = 'Erro de conexão']);
}

class ValidationException extends AppException {
  ValidationException(super.message);
}

class AuthException extends AppException {
  AuthException(super.message, {super.code});
}

class NotFoundException extends AppException {
  NotFoundException([super.message = 'Recurso não encontrado']);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Não autorizado']);
}

class StorageException extends AppException {
  StorageException([super.message = 'Erro ao acessar armazenamento local']);
}

class ConnectivityException extends AppException {
  ConnectivityException([super.message = 'Erro ao verificar conectividade']);
}
