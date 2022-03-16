import 'package:flutter/material.dart';

class ColorPoint extends StatelessWidget {
  final Color color;
  final EdgeInsetsGeometry? margin;

  const ColorPoint(
    this.color, {
    this.margin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: margin,
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
