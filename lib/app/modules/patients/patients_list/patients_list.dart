import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_list/controllers/patients_list_controller.dart';

import '../../main/main_screen.dart';
import 'layout/patients_list_desktop.dart';

class PatientsList extends GetView<PatientListController> {
  const PatientsList({super.key});
  @override
  Widget build(BuildContext context) {
    
    return  Obx(() => MainScreen(
        title: 'Pacientes',
        loader      : controller.brain.dataStatus.value,
        desktop     : const PatientsDesktopView(),
        mobile      : const PatientsDesktopView(),
        tablet      : const PatientsDesktopView(),
        headerAction: (){Get.offNamed('/patients/create');},
      )
    );
  }
}
