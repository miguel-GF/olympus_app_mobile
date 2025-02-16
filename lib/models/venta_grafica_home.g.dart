// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venta_grafica_home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VentaGraficaHome _$VentaGraficaHomeFromJson(Map<String, dynamic> json) =>
    VentaGraficaHome(
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$VentaGraficaHomeToJson(VentaGraficaHome instance) =>
    <String, dynamic>{
      'total': instance.total,
      'status': instance.status,
    };
