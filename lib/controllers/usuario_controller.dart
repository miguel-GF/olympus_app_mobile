import 'package:get/get.dart';

import '/models/usuario.dart';
import '/services/usuario_service.dart';
import '/utils/tool_util.dart';

class UsuarioController extends GetxController {
  Future<void> listar() async {
    try {
      await UsuarioService().listar();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Usuario>> buscar({
    required String usuario,
    required String password,
  }) async {
    try {
      final bool hayInternet = await ToolUtil().checkInternetConnection();
      if (!hayInternet) {
        // ignore: only_throw_errors
        throw 'No tiene conexión a internet';  
      }
      List<Usuario> usuarios = <Usuario>[];
      usuarios = await UsuarioService().buscar(
        usuario: usuario,
        password: password,
      );
      return usuarios;
    } catch (e) {
      rethrow;
    }
  }
}
