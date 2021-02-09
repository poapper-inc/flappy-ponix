import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  static const double width = 52.0;
  static const double height = 40.0;

  double getWidth() {
    return width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        child: Image.asset('lib/images/ponix.png', package: 'flappy_ponix', fit: BoxFit.fitWidth,)
    );
  }
}
