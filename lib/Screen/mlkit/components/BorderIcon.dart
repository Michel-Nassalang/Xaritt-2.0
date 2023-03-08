import 'package:flutter/material.dart';
    
class BorderIcon extends StatelessWidget {

  final Widget child;
  final EdgeInsets? padding;
  final double width, height;

  const BorderIcon(
      {Key? key, required this.child, this.padding, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(color: Color.fromARGB(160, 117, 117, 117), width: 1)),
        padding: padding,
        child: Center(child: child));
  }
}