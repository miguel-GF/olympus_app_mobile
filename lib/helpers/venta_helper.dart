import 'package:flutter/material.dart';

class VentaHelper {
  Widget buildStatusTag(String status) {
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

  Widget getPaymentIcon({required String formapago, double radius = 18, double size = 22}) {
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
      radius: radius,
      child: Icon(icon, color: Colors.white, size: size),
    );
  }
}
