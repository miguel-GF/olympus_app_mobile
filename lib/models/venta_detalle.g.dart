// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venta_detalle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VentaDetalle _$VentaDetalleFromJson(Map<String, dynamic> json) => VentaDetalle(
      idmovimientoinventario: (json['idmovimientoinventario'] as num).toInt(),
      folio: (json['folio'] as num).toInt(),
      clave: (json['clave'] as num).toInt(),
      concepto: json['concepto'] as String,
      familia: json['familia'] as String?,
      cantidad: json['cantidad'] as String,
      importe: json['importe'] as String,
    );

Map<String, dynamic> _$VentaDetalleToJson(VentaDetalle instance) =>
    <String, dynamic>{
      'idmovimientoinventario': instance.idmovimientoinventario,
      'folio': instance.folio,
      'clave': instance.clave,
      'concepto': instance.concepto,
      'familia': instance.familia,
      'cantidad': instance.cantidad,
      'importe': instance.importe,
    };
