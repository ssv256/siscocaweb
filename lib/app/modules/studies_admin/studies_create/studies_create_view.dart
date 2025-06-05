import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main/main_screen.dart';
import 'controllers/studies_create_controller.dart';
import 'layout/studies_create_desktop.dart';
import 'package:siscoca/routes/routes.dart';

class StudiesAdminCreateView extends GetView<StudyAdminCreateController> {
  const StudiesAdminCreateView({super.key});

  static const List<Map<String, String>> _routes = [
    {'label': 'Estudios', 'path': AppRoutes.studiesAdmin},
    {'label': 'Crear', 'path': AppRoutes.studiesAdminCreate}
  ];

  @override
  Widget build(BuildContext context) {
    return const MainScreen(
      title   : 'Crear estudio',
      routes  : _routes,
      loader  : true,
      desktop : StudiesCreateDesktopView(),
      mobile  : StudiesCreateDesktopView(),
      tablet  : StudiesCreateDesktopView(),
    );
  }
}