import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../main/main_screen.dart';
import 'controllers/survey_controller.dart';
import 'layout/survey_desktop.dart';

class SurveyView extends GetView<SurveyController> {
  const SurveyView({super.key});
  @override
  Widget build(BuildContext context) {
    
    return  Obx(() => MainScreen(
        title       : 'Cuestionarios',
        loader      : controller.brain.dataStatus.value,
        desktop     : const SurveyDesktopView(),
        mobile      : const SurveyDesktopView(),
        tablet      : const SurveyDesktopView(),
        headerAction: (){Get.offNamed('/survey/create');},
      )
    );
  }
}
