import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';

import '../../../../../widgets/inputs/input_dropdown_ed.dart';

/// Form for collecting patient pathology information
class FormCreatePathology extends GetView<PatientsCreateController> {
  const FormCreatePathology({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: controller.pathologyFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => controller.isLoadingPathologies.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildGeneralPathologyDropdown(),
                    const SizedBox(height: 15),
                    _buildSpecificPathologyDropdown(),
                    const SizedBox(height: 30),
                    FormSubmitButton(
                      formKey: controller.pathologyFormKey,
                      onSubmit: controller.validateAndContinue,
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralPathologyDropdown() {
    return Obx(() => InputDropDownEd(
      title: 'Patología General',
      width: double.infinity,
      value: controller.selectedGeneralPathology.value.isEmpty
          ? null
          : controller.selectedGeneralPathology.value,
      items: controller.availablePathologies,
      onChage: (value) {
        controller.onGeneralPathologySelected(value);
       
      },
      error: controller.generalPathologyError.value,
    ));
  }

  Widget _buildSpecificPathologyDropdown() {
    return Obx(() {

    final specificOptions = controller.availableSpecificPathologies.value;
    final selectedValue = controller.selectedSpecificPathology.value;
    
    return InputDropDownEd(
      title: 'Patología Específica',
      width: double.infinity,
      value: selectedValue.isEmpty ? null : selectedValue,
      items: specificOptions,
      onChage: controller.onSpecificPathologySelected,
      error: controller.specificPathologyError.value,
    );
  });
}

}