import '/models/venta.dart';
import '/models/venta_grafica_home.dart';
import '/utils/tool_util.dart';
import 'database_service.dart';

class VentaService {
  final DatabaseService dbService = DatabaseService();
  static String tableName = 'ventasRespaldoDos';

  Future<List<Venta>> listar({
    required String empresa,
    required String sucursal,
    required String fechaInicio,
    required String fechaFin,
  }) async {
    try {
      return await ToolUtil().handleDatabaseErrors(() async {
        final List<Map<String, dynamic>> ventas = await dbService.query(
          "SELECT v.idventas, v.fecha, v.hora, v.folio, v.cliente, v.total, v.formapago, v.status, v.empresa, v.sucursal, v.usuario FROM $tableName AS v WHERE v.empresa = ? AND v.sucursal = ? AND DATE_FORMAT(v.fecha, '%Y-%m-%d') BETWEEN ? AND ? ",
          <dynamic>[empresa, sucursal, fechaInicio, fechaFin],
        );

        return ventas
            .map((Map<String, dynamic> user) => Venta.fromJson(user))
            .toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VentaGraficaHome>> obtenerVentasConcentrado({
    required String empresa,
    required String sucursal,
    required String fechaInicio,
    required String fechaFin,
  }) async {
    try {
      return await ToolUtil().handleDatabaseErrors(() async {
        final List<Map<String, dynamic>> ventas = await dbService.query(
          "SELECT LOWER(v.status) AS status, SUM(COALESCE(v.total, 0)) AS total FROM $tableName AS v WHERE v.empresa = ? AND v.sucursal = ? AND DATE_FORMAT(v.fecha, '%Y-%m-%d') BETWEEN ? AND ? GROUP BY v.status",
          <dynamic>[empresa, sucursal, fechaInicio, fechaFin],
        );

        return ventas
            .map((Map<String, dynamic> user) => VentaGraficaHome.fromJson(user))
            .toList();
      });
    } catch (e) {
      rethrow;
    }
  }
}
