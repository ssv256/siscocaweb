
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main/main_screen.dart';
import '../controllers/home_controller.dart';
import '../layout/home_desktop.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
   
  @override
  Widget build(BuildContext context) {
    return    Obx(() => MainScreen(
        title   : 'HOME',
        routes  : const [{'name': 'Home'}],
        loader  : controller.brain.dataStatus.value,
        desktop : HomeDesktop(),
        mobile  : HomeDesktop(),
        tablet  : HomeDesktop(),
      )
    );
  }
}