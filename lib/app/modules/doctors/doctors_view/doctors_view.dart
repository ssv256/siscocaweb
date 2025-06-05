import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../main/main_screen.dart';
import 'controllers/doctors_controller.dart';
import 'layout/doctors_desktop.dart';

class DoctorsView extends GetView<DoctorController> {
  const DoctorsView({super.key});
  @override
  Widget build(BuildContext context) {
    return  Obx(() => MainScreen(
        title       : 'Doctores',
        loader      : controller.brain.dataStatus.value,
        desktop     : const DoctorsDesktopView(),
        mobile      : const DoctorsDesktopView(),
        tablet      : const DoctorsDesktopView(),
        headerAction: (){Get.offNamed('/doctors/create');},
      )
    );
  }
}
