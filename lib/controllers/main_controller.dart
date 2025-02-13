import 'package:get/get.dart';

import 'session_controller.dart';
import 'usuario_controller.dart';
import 'venta_controller.dart';

class MainController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Get.put(UsuarioController());
    Get.put(SessionController());
    Get.put(VentaController());
  }
}
