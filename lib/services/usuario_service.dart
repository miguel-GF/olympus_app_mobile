import 'database_service.dart';

class UsuarioService {
  final DatabaseService dbService = DatabaseService();
  static String tableName = 'usuarios';

  Future<void> listar() async {
    try {
      // Realizar consulta
      // final List<Map<String, dynamic>> users =
      //     await dbService.query('SELECT * FROM users WHERE age > ?', [18]);
      final List<Map<String, dynamic>> users = await dbService
          .query("SELECT * FROM $tableName WHERE status = 'ACTIVO'");
      print(users);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> buscar({
    required String usuario,
    required String password,
  }) async {
    try {
      // Realizar consulta
      final List<Map<String, dynamic>> users = await dbService.query(
          "SELECT * FROM $tableName WHERE correo = ? AND password = ? AND status = 'ACTIVO'",
          <dynamic>[usuario, password]);
      print(users);
    } catch (e) {
      rethrow;
    }
  }
}
