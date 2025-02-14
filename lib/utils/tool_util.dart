import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

class ToolUtil {
  Future<bool> checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else {
      return false;
    }
  }

  Future<T> handleDatabaseErrors<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on MySqlException catch (e) {
      switch (e.errorNumber) {
        case 1045:
          throw Exception('Acceso denegado: Credenciales incorrectas.');
        case 1049:
          throw Exception('Base de datos desconocida.');
        case 1054:
          throw Exception('Columna desconocida en la consulta.');
        case 1146:
          throw Exception('La tabla especificada no existe.');
        default:
          throw Exception('Error de MySQL (${e.errorNumber}): ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado de base de datos: $e');
    }
  }

  String formatCurrency(double amount) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: r'$',
      decimalDigits: 2,
    );

    return currencyFormat.format(amount);
  }
}
