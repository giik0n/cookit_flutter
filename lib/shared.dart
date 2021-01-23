import 'dart:ui' as ui;
import 'package:flutter/material.dart';

List<Color> ingridientColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow[700],
  Colors.green,
  Colors.lightBlueAccent,
  Colors.brown,
  Colors.grey,
  Colors.black,
];

class ShadowText extends StatelessWidget {
  ShadowText(this.data, {this.style}) : assert(data != null);

  final String data;
  final TextStyle style;

  Widget build(BuildContext context) {
    return new ClipRect(
      child: new Stack(
        children: [
          new Positioned(
            top: 2.0,
            left: 2.0,
            child: new Text(
              data,
              style: style.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          new BackdropFilter(
            filter: new ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: new Text(data, style: style),
          ),
        ],
      ),
    );
  }
}
