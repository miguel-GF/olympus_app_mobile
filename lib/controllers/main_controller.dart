import 'package:get/get.dart';

import 'usuario_controller.dart';

class MainController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Get.put(UsuarioController());
  }
}
