import 'package:flutter/material.dart';

class SingleListCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final dynamic onTap;
  final double height;

  const SingleListCard({
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    required this.child,
    this.onTap,
    this.height = 80
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height            : height,
      child             : InkWell(
        onTap: onTap,
        child: Container(
          margin      : margin,
          decoration  : BoxDecoration(
            color       : const Color.fromRGBO(46, 51, 82,1),
            borderRadius: BorderRadius.circular(15)
          ),
          child: child,
        )
      ),
    );
  }
}