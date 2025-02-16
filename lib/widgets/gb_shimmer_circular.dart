import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class GbShimmerCircular extends StatelessWidget {
  const GbShimmerCircular({
    super.key,
    required this.width,
    required this.height,
    this.thickness = 140,
  });
  final double width;
  final double height;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      SkeletonLine(
        style: SkeletonLineStyle(
          width: width,
          height: height,
          alignment: Alignment.center,
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      Container(
        width: thickness,
        height: thickness,
        decoration: BoxDecoration(
          color: Colors.white, // Fondo para ocultar el centro
          borderRadius: BorderRadius.circular((1000 - thickness) / 2),
        ),
      ),
    ]);
  }
}
