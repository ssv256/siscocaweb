import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patients_detail_controller.dart';
import '../widgets/patients_information_widget.dart';
import '../widgets/patients_tabs.dart';

class PatientsDetailDesktop extends GetView<PatientsDetailController> {
  const PatientsDetailDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
        maxHeight: size.height * 0.9,
        minHeight: 100,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.1,
            child: const PatientsInformationWidget(),
          ),
          const SizedBox(height: 16),
          const Expanded(child: PatientsTabs()),
        ],
      ),
    );
  }
}