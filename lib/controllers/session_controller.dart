import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '/models/usuario.dart';
import '/routes/routes_names.dart';

class SessionController extends GetxController {
  final Uuid _uuid = const Uuid();
  final Rx<Usuario> _usuario = Usuario(
    claveusuario: '',
    correo: '',
    empresa: '',
    id: 0,
    nombre: '',
    sucursal: '',
    tipo: '',
  ).obs;
  // Getter para obtener el usuario
  Usuario get usuario => _usuario.value;
  // Setter para actualizar el usuario
  // set usuario(Usuario newUser) {
  //   _usuario.value = newUser;
  // }

  Future<void> saveSession(Usuario usuario) async {
    // Almacenamos datos de usuario
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> usuarioMap = usuario.toJson();
    await prefs.setString('usuario', jsonEncode(usuarioMap));
    _usuario.value = usuario;
    // Genera un token único
    final String token = _uuid.v4();
    // Establece la fecha de expiración (por ejemplo, 1 hora desde ahora)
    final DateTime expiration = DateTime.now().add(const Duration(hours: 8));
    // Guarda el token y la fecha de expiración
    await prefs.setString('authToken', token);
    await prefs.setString('tokenExpiration', expiration.toIso8601String());
  }

  Future<bool> isTokenValid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? expirationStr = prefs.getString('tokenExpiration');
    if (expirationStr == null) {
      return false;
    }

    final DateTime expiration = DateTime.parse(expirationStr);

    // Verifica si el token sigue siendo válido
    return DateTime.now().isBefore(expiration);
  }

  Future<Usuario> getUsuario() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usuarioKey = prefs.getString('usuario');
    final Map<String, dynamic> usuarioMap = jsonDecode(usuarioKey!);
    final Usuario usuario = Usuario.fromJson(usuarioMap);
    return usuario;
  }

  Future<String> getUsuarioEmpresa() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usuarioKey = prefs.getString('usuario');
    final Map<String, dynamic> usuarioMap = jsonDecode(usuarioKey!);
    final Usuario usuario = Usuario.fromJson(usuarioMap);
    return usuario.empresa;
  }

  Future<String> getUsuarioSucursal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usuarioKey = prefs.getString('usuario');
    final Map<String, dynamic> usuarioMap = jsonDecode(usuarioKey!);
    final Usuario usuario = Usuario.fromJson(usuarioMap);
    return usuario.sucursal;
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenExpiration');
  }

  Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _usuario.value = Usuario(
      claveusuario: '',
      correo: '',
      empresa: '',
      id: 0,
      nombre: '',
      sucursal: '',
      tipo: '',
    );
    Get.offAllNamed(nameLoginScreen);
    // await prefs.remove('usuario');
    // await prefs.remove('authToken');
    // await prefs.remove('tokenExpiration');
  }
}
