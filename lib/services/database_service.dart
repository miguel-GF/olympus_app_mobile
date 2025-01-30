import 'package:mysql1/mysql1.dart';

class DatabaseService {
  Future<MySqlConnection> connect() async {
    final ConnectionSettings settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      timeout: const Duration(seconds: 30),
      user: 'user',
      password: '****',
      db: 'dbname',
    );

    return MySqlConnection.connect(settings);
  }

  Future<List<Map<String, dynamic>>> query(String sql, [List<dynamic>? params]) async {
    final MySqlConnection connection = await connect();
    try {
      final Results results = await connection.query(sql, params);
      return results.map((ResultRow row) => row.fields).toList();
    } finally {
      await connection.close();
      print('cerro conexion de mysql');
    }
  }
}
