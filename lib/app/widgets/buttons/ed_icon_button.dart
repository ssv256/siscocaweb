import 'package:flutter/material.dart';

class EdIconBtn extends StatelessWidget {
  final dynamic icon;
  final dynamic onTap;
  final Color color;
  final bool bg;
  const EdIconBtn({
    super.key,
    this.icon,
    this.onTap,
    this.color = Colors.amber,
    this.bg = true
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap : onTap,
      child : Container(
        padding   : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color       : bg ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(5)
        ),
        child     :  Icon(icon, color: color, size: 20),
      ),
    );
  }
}