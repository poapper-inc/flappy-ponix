import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final size;
  final type;
  static const double width = 108.0;
  Barrier({this.size, this.type});

  double getWidth() {
    return width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: size,
      decoration: BoxDecoration(
        //color: Colors.green,
        //border: Border.all(width: 10, color: Colors.green[800]),
        //borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          type == "BOTTOM" ? Image.asset('lib/images/barrier_top.png', package: 'flappy_ponix', width: width,) : Container(),
          Expanded(child: Image.asset('lib/images/barrier_body.png', package: 'flappy_ponix', width: width, height: size-74, fit: BoxFit.fill)),
          type == "TOP" ? Image.asset('lib/images/barrier_bottom.png', package: 'flappy_ponix', width: width,) : Container(),
        ],
      )
    );
  }
}
