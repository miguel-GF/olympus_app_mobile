// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../controllers/session_controller.dart';
import '../../controllers/venta_controller.dart';
import '../../helpers/venta_helper.dart';
import '../../models/venta.dart';
import '../../models/venta_detalle.dart';
import '../../utils/tool_util.dart';

class VentaDetalleScreen extends StatelessWidget {
  const VentaDetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Venta venta = Get.arguments as Venta;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Venta')),
      body: Column(
        children: <Widget>[
          _buildResumenVenta(context, venta),
          Expanded(child: _buildListaProductos(venta)),
        ],
      ),
    );
  }

  Widget _buildResumenVenta(BuildContext context, Venta venta) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Folio: ${venta.folio}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(
                    'Cliente: ${venta.cliente}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  Text(
                    'Fecha: ${venta.fecha} ${venta.hora}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
              VentaHelper().getPaymentIcon(
                  formapago: venta.formapago, radius: 28, size: 28),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Total: ${ToolUtil().formatCurrency(venta.total)}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              VentaHelper().buildStatusTag(venta.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListaProductos(Venta venta) {
    return FutureBuilder<List<VentaDetalle>>(
      future: fetchProductos(venta),
      builder:
          (BuildContext context, AsyncSnapshot<List<VentaDetalle>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.dotsTriangle(
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar productos'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay productos en esta venta'));
        }

        final List<VentaDetalle> productos = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: productos.length,
          itemBuilder: (BuildContext context, int index) {
            final VentaDetalle producto = productos[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                title: AutoSizeText(
                  producto.concepto.trim(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('Clave: ${producto.clave}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('Cantidad: ${producto.cantidad}',
                        style: const TextStyle(fontSize: 14)),
                    Text(
                      'Total: ${ToolUtil().formatCurrency(double.tryParse(producto.importe)!)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<VentaDetalle>> fetchProductos(Venta venta) async {
    // Simulación de fetch desde base de datos o API
    final SessionController sessionController = Get.find<SessionController>();
    final VentaController ventaController = Get.find<VentaController>();
    final List<VentaDetalle> ventaDetalles =
        await ventaController.listarDetalleVenta(
      empresa: sessionController.usuario.empresa,
      sucursal: sessionController.usuario.sucursal,
      folio: venta.folio,
    );
    return ventaDetalles;
  }
}
