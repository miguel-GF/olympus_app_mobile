import 'package:json_annotation/json_annotation.dart';

part 'venta_grafica_home.g.dart';

@JsonSerializable()
class VentaGraficaHome {
  VentaGraficaHome({
    required this.total,
    required this.status,
  });

  factory VentaGraficaHome.fromJson(Map<String, dynamic> json) =>
      _$VentaGraficaHomeFromJson(json);
  final double total;
  final String status;

  Map<String, dynamic> toJson() => _$VentaGraficaHomeToJson(this);
}
