import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main/main_screen.dart';
import 'controllers/patients_create_controller.dart';
import 'layout/patients_create_desktop.dart';
import 'package:siscoca/routes/routes.dart';

class PatientsCreateView extends GetView<PatientsCreateController> {
 const PatientsCreateView({super.key});

 @override
 Widget build(BuildContext context) {
   final isEditing = Get.arguments != null;
   return MainScreen(
     title: isEditing ? 'Editar paciente' : 'Crear paciente',
     routes: [
       const {'label': 'Pacientes', 'path': AppRoutes.patients},
       {'label': isEditing ? 'Editar Paciente' : 'Crear Paciente', 'path': AppRoutes.patientsCreate}
     ],
     loader: true,
     desktop: const PatientsCreateDesktopView(),
     mobile: const PatientsCreateDesktopView(), 
     tablet: const PatientsCreateDesktopView(),
   );
 }
}