import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 60,
        child: Image.asset('lib/images/ponix.png', package: 'flappy_ponix',)
    );
  }
}
