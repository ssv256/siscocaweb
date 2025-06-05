import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../main/main_screen.dart';
import 'controllers/studies_controller.dart';
import 'layout/studies_desktop.dart';

class StudiesView extends GetView<StudyController> {
  const StudiesView({super.key});
  @override
  Widget build(BuildContext context) {
    
    return  Obx(() => MainScreen(
        title       : 'Estudios',
        loader      : controller.brain.dataStatus.value,
        desktop     : const StudiesDesktopView(),
        mobile      : const StudiesDesktopView(),
        tablet      : const StudiesDesktopView(),
        // headerAction: (){Get.offNamed('/studies/create');},
      )
    );
  }
}
