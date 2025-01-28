import 'package:flutter/material.dart';

class GbButton extends StatelessWidget {
  const GbButton({
    super.key,
    this.texto = 'Aceptar',
    this.accion = 'primaria',
    this.iconoDerecha,
    this.iconoIzquierda,
    this.onPressed,
  });
  final String texto;
  final String accion;
  final Widget? iconoDerecha;
  final Widget? iconoIzquierda;
  final VoidCallback? onPressed;

  Widget botonPrimario() {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: iconoIzquierda != null,
            child: iconoIzquierda != null ? iconoIzquierda! : const SizedBox(),
          ),
          Expanded(
            child: Text(
              texto.toUpperCase(),
              textAlign: TextAlign.center,
            ),
          ),
          Visibility(
            visible: iconoDerecha != null,
            child: iconoDerecha != null ? iconoDerecha! : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget botonSecundario() {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: iconoIzquierda != null,
            child: iconoIzquierda != null ? iconoIzquierda! : const SizedBox(),
          ),
          Expanded(
            child: Text(
              texto.toUpperCase(),
              textAlign: TextAlign.center,
            ),
          ),
          Visibility(
            visible: iconoDerecha != null,
            child: iconoDerecha != null ? iconoDerecha! : const SizedBox(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (accion == 'primaria') {
      return botonPrimario();
    }
    return botonSecundario();
  }
}
