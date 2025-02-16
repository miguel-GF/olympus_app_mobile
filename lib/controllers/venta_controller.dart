import 'package:get/get.dart';

import '/models/venta.dart';
import '/models/venta_grafica_home.dart';
import '/services/venta_service.dart';
import '/utils/tool_util.dart';

class VentaController extends GetxController {

  Future<List<Venta>> listar({
    required String empresa,
    required String sucursal,
    required String fechaInicio,
    required String fechaFin,
  }) async {
    try {
      final bool hayInternet = await ToolUtil().checkInternetConnection();
      if (!hayInternet) {
        // ignore: only_throw_errors
        throw 'No tiene conexión a internet';  
      }
      List<Venta> ventas = <Venta>[];
      ventas = await VentaService().listar(
        empresa: empresa,
        sucursal: sucursal,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
      return ventas;
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
      final bool hayInternet = await ToolUtil().checkInternetConnection();
      if (!hayInternet) {
        // ignore: only_throw_errors
        throw 'No tiene conexión a internet';  
      }
      List<VentaGraficaHome> ventas = <VentaGraficaHome>[];
      ventas = await VentaService().obtenerVentasConcentrado(
        empresa: empresa,
        sucursal: sucursal,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
      return ventas;
    } catch (e) {
      rethrow;
    }
  }
}
