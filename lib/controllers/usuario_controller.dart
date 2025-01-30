import 'package:get/get.dart';

import '/services/usuario_service.dart';

class UsuarioController extends GetxController {
  Future<void> listar() async {
    try {
      await UsuarioService().listar();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> buscar({
    required String usuario,
    required String password,
  }) async {
    try {
      await UsuarioService().buscar(
        usuario: usuario,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }
}
