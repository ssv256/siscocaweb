import 'package:flutter/material.dart';
import 'package:siscoca/app/modules/main/drawer/drawer.dart';

class ResponsiveDrawer extends StatelessWidget {
  static const double kDesktopBreakpoint = 1024;
  
  final double width;
  final Widget? drawer;

  const ResponsiveDrawer({
    super.key,
    required this.width,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    if (width > kDesktopBreakpoint) return const Text('null');
    return drawer ?? const DrawerApp();
  }
}
