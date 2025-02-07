import '/models/usuario.dart';
import '/utils/tool_util.dart';
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

  Future<List<Usuario>> buscar({
    required String usuario,
    required String password,
  }) async {
    try {
      return await ToolUtil().handleDatabaseErrors(() async {
        final List<Map<String, dynamic>> users = await dbService.query(
          "SELECT * FROM $tableName WHERE correo = ? AND password = ? AND status = 'ACTIVO'",
          <dynamic>[usuario, password],
        );

        return users
            .map((Map<String, dynamic> user) => Usuario.fromJson(user))
            .toList();
      });
    } catch (e) {
      rethrow;
    }
  }
}
