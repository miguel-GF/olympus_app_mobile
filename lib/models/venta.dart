import 'package:json_annotation/json_annotation.dart';

part 'venta.g.dart';

@JsonSerializable()
class Venta {
  Venta({
    required this.idventas,
    required this.fecha,
    required this.hora,
    required this.folio,
    required this.cliente,
    required this.total,
    required this.formapago,
    required this.status,
    required this.empresa,
    required this.sucursal,
    required this.usuario,
  });

  factory Venta.fromJson(Map<String, dynamic> json) => _$VentaFromJson(json);
  final int idventas;
  final String fecha;
  final String hora;
  final int folio;
  final String cliente;
  final double total;
  final String formapago;
  final String status;
  final String empresa;
  final String sucursal;
  final String usuario;

  Map<String, dynamic> toJson() => _$VentaToJson(this);
}
