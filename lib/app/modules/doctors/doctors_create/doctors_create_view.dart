import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/routes/routes.dart';

import '../../main/main_screen.dart';
import 'controllers/doctors_create_controller.dart';
import 'layout/doctors_create_desktop.dart';

class DoctorsCreateView extends GetView<DoctorCreateController> {
  const DoctorsCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return    Obx(() => MainScreen(
      title   : 'Crear doctor',
      routes  : const [
        {'label': 'Doctores', 'path': AppRoutes.doctors},
        {'label': 'Crear', 'path': AppRoutes.doctorsCreate}
      ],
      loader  : controller.brain.dataStatus.value,
      desktop : const DoctorsCreateDesktopView(),
      mobile  : const DoctorsCreateDesktopView(),
      tablet  : const DoctorsCreateDesktopView()
    ));
  }
}