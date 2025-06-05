import 'package:flutter/material.dart';

class ResponsiveBreakpoints {
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= 1200;
      
  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= 800 && 
      MediaQuery.of(context).size.width < 1200;
      
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < 800;
}