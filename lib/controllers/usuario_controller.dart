import 'package:get/get.dart';

import '/models/usuario.dart';
import '/services/usuario_service.dart';
import '/utils/exception_util.dart';
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
        throw ConnectionException();
      }
      List<Usuario> usuarios = <Usuario>[];
      usuarios = await UsuarioService().buscar(
        usuario: usuario,
        password: password,
      );
      if (usuarios.isEmpty) {
        throw AuthenticationException();
      }
      return usuarios;
    } catch (e) {
      rethrow;
    }
  }
}
