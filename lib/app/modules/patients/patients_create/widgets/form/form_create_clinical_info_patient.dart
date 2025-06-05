import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';
import 'package:siscoca/app/widgets/inputs/main_input.dart';
import 'package:siscoca/app/widgets/inputs/multi_select_dropdown.dart';
import '../../../../../widgets/inputs/input_dropdown_ed.dart';


class FormClinicalInfo extends GetView<PatientsCreateController> {
 const FormClinicalInfo({super.key});

  Widget _buildClinicalDropdown({
   required String field,
   required ClinicalDropdownConfig config,
   List<String>? customOptions,
  }) {
    return Obx(() => InputDropDownEd(
      title: config.title,
      width: double.infinity,
      value: clinicalValues[field]?.value ?? config.defaultValue,
      items: customOptions ?? config.options,
      onChage: (String? newValue) => 
        controller.updateClinicalValue(field, newValue ?? config.defaultValue),
      error: clinicalErrors[field]?.value ?? false,
    ));
  }

 @override
 Widget build(BuildContext context) {
   return Form(
     key: controller.clinicalInfoFormKey,
     child: SingleChildScrollView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          _buildClinicalDropdown(
            field: 'endocarditis',
            config: dropdownConfigs['endocarditis']!,
          ),
          const SizedBox(height: 20),
          const Divider(),
           
          _buildClinicalDropdown(
            field: 'deviceCarrier',
            config: dropdownConfigs['deviceCarrier']!,
          ),
          const SizedBox(height: 20),
          TextFieldWidget(
            title: 'Marca del dispositivo', 
            controller: controller.deviceBrandsController,
            required: false,
          ),
          const SizedBox(height: 20),
          const Divider(),
             
          _buildClinicalDropdown(
            field: 'pregnancyRisk',
            config: dropdownConfigs['pregnancyRisk']!,
          ),

          const SizedBox(height: 20),
          const Divider(),
        
          _buildClinicalDropdown(
            field: 'anticoagulation', 
            config: dropdownConfigs['anticoagulation']!,
          ),
          const SizedBox(height: 20),
          TextFieldWidget(
            title: 'Medicación anticoagulante',
            controller: controller.anticoagulationMedsController,
            required: false,
          ),

          const SizedBox(height: 20),
          const Divider(),

          Obx(() => MultiSelectDropDownEd(
            title: 'Estudios',
            width: double.infinity,
            options: controller.availableStudies.map((study) => study.studyName).toList(),
            values: controller.selectedStudies.map((study) => study.studyName).toList(),
            onChanged: (List<String> newValues) => controller.updateSelectedStudies(newValues),
            error: false,
          )),

          const SizedBox(height: 20),

          FormSubmitButton(
            formKey: controller.clinicalInfoFormKey,
            onSubmit: controller.validateAndContinue,
          ),
         ],
       )),
     );
 }
}

/// Configuration for clinical dropdown fields
class ClinicalDropdownConfig {
  final String title;
  final List<String> options;
  final String? helpTitle;
  final String? helpContent;
  final String defaultValue;

  const ClinicalDropdownConfig({
    required this.title,
    required this.options,
    this.helpTitle,
    this.helpContent,
    required this.defaultValue,
  });
}

const Map<String, ClinicalDropdownConfig> dropdownConfigs = {
    'endocarditis': ClinicalDropdownConfig(
      title: 'Riesgo de endocarditis',
      options: ['No', 'Si'],
      helpTitle: 'Riesgo de endocarditis',
      helpContent: 'El riesgo de endocarditis es una infección de las válvulas del corazón o de las superficies '
          'internas del corazón. Se produce cuando las bacterias entran en el torrente sanguíneo y se adhieren '
          'a una válvula cardíaca dañada.',
      defaultValue: 'No',
    ),
    'deviceCarrier': ClinicalDropdownConfig(
      title: 'Portador de dispositivo',
      options: ['No', 'Marcapaso', 'DAI', 'DAI-TRC', 'DAI-MP'],
      defaultValue: 'No',
    ),
    'pregnancyRisk': ClinicalDropdownConfig(
      title: 'Riesgo de embarazo',
      options: [
        'Riesgo nulo o muy reducido',
        'Ligero aumento de mortalidad o moderado aumento de empeoramiento clínico. Consultar previamente con su cardiólogo',
        'Aumento significativo del riesgo de mortalidad o complicaciones graves. Consultar previamente con su cardiólogo',
        'Riesgo extremadamente alto de muerte o complicaciones graves. Se desaconseja el embarazo. Consultar con su cardiólogo.',
      ],
      defaultValue: 'Riesgo nulo o muy reducido',
    ),
    'anticoagulation': ClinicalDropdownConfig(
      title: 'Anticoagulación',
      options: ['No', 'Si'],
      defaultValue: 'No',
    ),
  };