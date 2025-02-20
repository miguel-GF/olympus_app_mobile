class ConnectionException implements Exception {
  ConnectionException([this.message = 'No tiene conexión a internet']);
  final String message;

  @override
  String toString() => message;
}

class DatabaseException implements Exception {
  DatabaseException([this.message = 'Error en la base de datos']);
  final String message;

  @override
  String toString() => message;
}

class AuthenticationException implements Exception {
  AuthenticationException([this.message = 'Credenciales incorrectas']);
  final String message;

  @override
  String toString() => message;
}
