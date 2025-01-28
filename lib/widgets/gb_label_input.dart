import 'package:flutter/material.dart';

class GbInputLabel extends StatelessWidget {
  const GbInputLabel({
    super.key,
    required this.texto,
    this.alineacionHorizontal = CrossAxisAlignment.start,
  });
  final String texto;
  final CrossAxisAlignment alineacionHorizontal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: alineacionHorizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              texto,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
