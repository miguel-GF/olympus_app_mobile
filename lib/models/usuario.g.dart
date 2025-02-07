// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usuario _$UsuarioFromJson(Map<String, dynamic> json) => Usuario(
      id: (json['id'] as num).toInt(),
      correo: json['correo'] as String,
      empresa: json['empresa'] as String,
      claveusuario: json['claveusuario'] as String,
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String,
    );

Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
      'id': instance.id,
      'correo': instance.correo,
      'empresa': instance.empresa,
      'claveusuario': instance.claveusuario,
      'nombre': instance.nombre,
      'tipo': instance.tipo,
    };
