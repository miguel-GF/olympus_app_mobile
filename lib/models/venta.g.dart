// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Venta _$VentaFromJson(Map<String, dynamic> json) => Venta(
      idventas: (json['idventas'] as num).toInt(),
      fecha: json['fecha'] as String,
      hora: json['hora'] as String,
      folio: (json['folio'] as num).toInt(),
      cliente: json['cliente'] as String,
      total: (json['total'] as num).toDouble(),
      formapago: json['formapago'] as String,
      status: json['status'] as String,
      empresa: json['empresa'] as String,
      sucursal: json['sucursal'] as String,
      usuario: json['usuario'] as String,
    );

Map<String, dynamic> _$VentaToJson(Venta instance) => <String, dynamic>{
      'idventas': instance.idventas,
      'fecha': instance.fecha,
      'hora': instance.hora,
      'folio': instance.folio,
      'cliente': instance.cliente,
      'total': instance.total,
      'formapago': instance.formapago,
      'status': instance.status,
      'empresa': instance.empresa,
      'sucursal': instance.sucursal,
      'usuario': instance.usuario,
    };
