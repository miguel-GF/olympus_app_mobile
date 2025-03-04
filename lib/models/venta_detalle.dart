import 'package:json_annotation/json_annotation.dart';

part 'venta_detalle.g.dart';

@JsonSerializable()
class VentaDetalle {
  VentaDetalle({
    required this.idmovimientoinventario,
    required this.folio,
    required this.clave,
    required this.concepto,
    this.familia,
    required this.cantidad,
    required this.importe,
  });

  factory VentaDetalle.fromJson(Map<String, dynamic> json) =>
      _$VentaDetalleFromJson(json);
  final int idmovimientoinventario;
  final int folio;
  final int clave;
  final String concepto;
  final String? familia;
  final String cantidad;
  final String importe;

  Map<String, dynamic> toJson() => _$VentaDetalleToJson(this);
}
