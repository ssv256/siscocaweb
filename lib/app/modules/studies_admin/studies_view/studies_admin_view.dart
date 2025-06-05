import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/studies_admin/index.dart';
import '../../main/main_screen.dart';

class StudiesAdminView extends GetView<StudyAdminController> { 
  const StudiesAdminView({super.key});
  @override
  Widget build(BuildContext context) {
    
    return  Obx(() => MainScreen(
        title       : 'Estudios',
        loader      : controller.brain.dataStatus.value,
        desktop     : const StudiesDesktopView(),
        mobile      : const StudiesDesktopView(),
        tablet      : const StudiesDesktopView(),
        headerAction: (){Get.offNamed('/studies-admin/create');},
      )
    );
  }
}
