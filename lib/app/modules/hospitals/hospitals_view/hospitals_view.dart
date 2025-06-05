import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../main/main_screen.dart';
import 'controllers/hospitals_controller.dart';
import 'layout/hospitals_desktop.dart';

class HospitalsView extends GetView<HospitalController> {
  const HospitalsView({super.key});
  @override
  Widget build(BuildContext context) {
    return  Obx(() => MainScreen(
        title       : 'Hospitales',
        loader      : controller.brain.dataStatus.value,
        desktop     : const HospitalsDesktopView(),
        mobile      : const HospitalsDesktopView(),
        tablet      : const HospitalsDesktopView(),
        headerAction: (){Get.offNamed('/hospitals/create');},
      )
    );
  }
}
