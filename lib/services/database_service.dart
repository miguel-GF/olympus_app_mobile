import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql1/mysql1.dart';

class DatabaseService {
  Future<MySqlConnection> connect() async {
    final ConnectionSettings settings = ConnectionSettings(
      host: dotenv.env['HOST']!,
      port: int.tryParse(dotenv.env['PORT']!) ?? 3306,
      timeout: Duration(seconds: int.tryParse(dotenv.env['TIMEOUT']!) ?? 60),
      user: dotenv.env['USER'],
      password: dotenv.env['PASSWORD'],
      db: dotenv.env['DBNAME'],
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
