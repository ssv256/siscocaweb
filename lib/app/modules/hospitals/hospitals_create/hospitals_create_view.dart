import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/routes/routes.dart';

import '../../main/main_screen.dart';
import 'controllers/hospitals_create_controller.dart';
import 'layout/hospitals_create_desktop.dart';

class HospitalsCreateView extends GetView<HospitalCreateController> {
  const HospitalsCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => MainScreen(
      title   : 'Crear hospital',
      routes  : const [
        {'label': 'Hospitales', 'path': AppRoutes.hospitals},
        {'label': 'Crear', 'path': AppRoutes.hospitalsCreate}
      ],
      loader  : controller.brain.dataStatus.value,
      desktop : const HospitalsCreateDesktopView(),
      mobile  : const HospitalsCreateDesktopView(),
      tablet  : const HospitalsCreateDesktopView(),
    ));
  }
}