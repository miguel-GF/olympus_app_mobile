import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/venta_helper.dart';
import '../../models/venta.dart';
import '../../routes/routes_names.dart';
import '../../utils/tool_util.dart';

class VentaItemWidget extends StatelessWidget {
  const VentaItemWidget({super.key, required this.venta});
  final Venta venta;

  void _onTap() {
    Get.toNamed(ventaDetalleScreen, arguments: venta);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AutoSizeText(
                    venta.folio.toString(),
                    style: Theme.of(context).textTheme.displaySmall,
                    maxLines: 1,
                    minFontSize: 11,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  VentaHelper().getPaymentIcon(formapago: venta.formapago),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: AutoSizeText(
                        venta.cliente,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        minFontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${venta.fecha} ${venta.hora}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    ToolUtil().formatCurrency(venta.total),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 4),
                  VentaHelper().buildStatusTag(venta.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
