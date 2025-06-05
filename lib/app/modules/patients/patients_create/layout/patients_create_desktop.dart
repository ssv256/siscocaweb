import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';
import 'package:siscoca/core/extensions/responsive_breakpoint.dart';
import '../../../../widgets/list/list_Template.dart';
import '../widgets/form/form_create_clinical_info_patient.dart';

class PatientsCreateDesktopView extends GetView<PatientsCreateController> {
  const PatientsCreateDesktopView({super.key});

    @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: const EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height - 140,
      width: _getResponsiveWidth(context),
      child: ListTemplate(
        controller: ScrollController(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 180,
                child: const TabFormNav(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: const VerticalDivider(),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _getFormByIndex(),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _getFormByIndex() {
    switch (controller.currentFormIndex.value) {
      case 0:
        return const FormCreatePatient();
      case 1:
        return const FormConstantsPatient();
      case 2:
        return const FormCreateAlertThresholds();
      case 3:  
        return const FormCreatePathology();
      case 4:
        return const FormClinicalInfo();
      case 5:
        return const FormProcedures();
      case 6:
        return const FormResidualLesions();
      case 7:
        return const FormCreateMedication();
      default:
        return const FormCreatePatient();
    }
  }

  /// Calculates responsive width based on screen size
  double _getResponsiveWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (ResponsiveBreakpoints.isDesktop(context)) {
      return width / 1.7;
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return width / 1.2;
    }
    return width;
  }
}