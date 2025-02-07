import 'package:json_annotation/json_annotation.dart';

part 'usuario.g.dart';

@JsonSerializable()
class Usuario {

  Usuario({
    required this.id,
    required this.correo,
    required this.empresa,
    required this.claveusuario,
    required this.nombre,
    required this.tipo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => _$UsuarioFromJson(json);
  final int id;
  final String correo;
  final String empresa;
  final String claveusuario;
  final String nombre;
  final String tipo;

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);
}
