import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/routes/routes.dart';

import '../../main/main_screen.dart';
import 'controllers/surveys_create_controller.dart';
import 'layout/surveys_create_desktop.dart';

class SurveysCreateView extends GetView<SurveysCreateController> {
  const SurveysCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    // Call onViewOpen when the view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.onViewOpen();
    });
    
    return Obx(() => MainScreen(
      title   : 'Crear questionario',
      routes  : const [
        {'label': 'Cuestionario', 'path': AppRoutes.survey},
        {'label': 'Crear', 'path': AppRoutes.surveyCreate}
      ],
      loader  : controller.brain.dataStatus.value,
      desktop : const SurveysCreateDesktopView(),
      mobile  : const SurveysCreateDesktopView(),
      tablet  : const SurveysCreateDesktopView()
    ));
  }
}