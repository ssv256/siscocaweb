import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/routes/routes.dart';

import '../../main/main_screen.dart';
import 'controllers/patients_detail_controller.dart';
import 'layout/patients_detail_desktop.dart';

class PatientsDetailView extends GetView<PatientsDetailController> {
  const PatientsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainScreen(
      enableScroll: false,
      loader  : true,
      title   : 'Detalle de Paciente',
      routes  : [
        {'label': 'Pacientes', 'path': AppRoutes.patients},
        {'label': 'Detalle', 'path': AppRoutes.patientsDetail}
      ],
      desktop : PatientsDetailDesktop(),
      mobile  : PatientsDetailDesktop(),
      tablet  : PatientsDetailDesktop(),
    );
  }
}
