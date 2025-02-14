import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../models/venta.dart';
import '../../utils/tool_util.dart';

class VentaItemWidget extends StatelessWidget {
  const VentaItemWidget({super.key, required this.venta});
  final Venta venta;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            _getPaymentIcon(venta.formapago),
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
                _buildStatusTag(venta.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar el estado como una etiqueta de color
  Widget _buildStatusTag(String status) {
    Color bgColor;
    switch (status.toUpperCase()) {
      case 'PAGADO':
        bgColor = Colors.green;
        break;
      case 'PENDIENTE':
        bgColor = Colors.orange;
        break;
      case 'CANCELADO':
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
            fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Método para obtener el icono correspondiente a la forma de pago
  Widget _getPaymentIcon(String formapago) {
    IconData icon;
    switch (formapago.toLowerCase()) {
      case 'cheque':
        icon = Icons.request_page;
        break;
      case 'credito':
        icon = Icons.account_balance_wallet;
        break;
      case 'efectivo':
        icon = Icons.money;
        break;
      case 'monedero electronico':
        icon = Icons.credit_card;
        break;
      case 'tarjeta de credito':
        icon = Icons.credit_card;
        break;
      case 'tarjeta de debito':
        icon = Icons.credit_card;
        break;
      case 'transferencia':
      case 'transferencia electronica de fondos':
        icon = Icons.swap_horiz;
        break;
      default:
        icon = Icons.payment;
    }

    return CircleAvatar(
      backgroundColor: Colors.blueAccent,
      radius: 22,
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
