import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget child;
  final Color? color;
  

  const MainCard({
    super.key,
    this.width  = double.infinity,
    this.height = double.infinity,
    this.margin = const EdgeInsets.all(8),
    this.padding = const EdgeInsets.all(8),
    required this.child,
    this.color = const Color.fromARGB(120, 255, 255, 255),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height    : height,
      width     : width,
      margin    : margin,
      padding   : padding,
      decoration: BoxDecoration(
        color       : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow   : const [
          BoxShadow(
            color       : Color.fromARGB(10, 0, 0, 0),
            blurRadius  : 5,
            spreadRadius: 2,
            offset      : Offset(0, 2),
          )
        ]
      ),
      child     : child,
    );
  }
}