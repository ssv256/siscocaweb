import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';
import '../../../../../widgets/inputs/main_input.dart';

class FormConstantsPatient extends GetView<PatientsCreateController> {
  const FormConstantsPatient({super.key});
   
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: controller.constantsFormKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBasicMeasurements(),
                const SizedBox(height: 20),
                const Divider(),
                _buildVitalSignSection(
                  title: 'Saturación de oxígeno',
                  field: 'oxygen',
                  selectedValue: controller.oxygenLevel,
                  textController: controller.oxygenController,
                  ranges: vitalSignsRanges['oxygen']!,
                  unit: '%',
                ),
                const Divider(),
                _buildVitalSignSection(
                  title: 'Presión arterial',
                  field: 'bloodPressure',
                  selectedValue: controller.bloodPressure,
                  textController: controller.bloodPressureController,
                  ranges: vitalSignsRanges['bloodPressure']!,
                  unit: 'mmHg',
                ),
                const Divider(),
                _buildVitalSignSection(
                  title: 'Frecuencia cardíaca',
                  field: 'heartRate',
                  selectedValue: controller.heartRate,
                  textController: controller.heartRateController,
                  ranges: vitalSignsRanges['heartRate']!,
                  unit: 'bpm',
                ),
                const SizedBox(height: 30),
                FormSubmitButton(
                  formKey: controller.constantsFormKey,
                  onSubmit: controller.validateAndContinue,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    ); 
  }

  Widget _buildBasicMeasurements() {
    return Column(
      children: [
        TextFieldWidget(
          title: 'Peso (kg)',
          controller: controller.weightController,
          required: true,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return 'El peso es requerido';
            }
            if (double.tryParse(value) == null) {
              return 'Ingrese un valor numérico válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          title: 'Altura (cm)',
          controller: controller.heightController,
          required: true,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return 'La altura es requerida';
            }
            if (double.tryParse(value) == null) {
              return 'Ingrese un valor numérico válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildVitalSignSection({
    required String title,
    required String field,
    required RxString selectedValue,
    required TextEditingController textController,
    required List<VitalSignRange> ranges,
    String? unit,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 450;
                return isNarrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth,
                            child: TextFieldWidget(
                              title: '$title${unit != null ? ' ($unit)' : ''}',
                              controller: textController,
                              required: true,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return '$title es requerido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: ranges.map((range) => Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: VitalSignRadio(
                                  label: range.label,
                                  color: range.color,
                                  range: range.range,
                                  displayText: range.displayText,
                                  selected: selectedValue.value == range.label,
                                  onTap: () {
                                    selectedValue.value = range.label;
                                    textController.text = range.displayText;
                                  },
                                ),
                              )).toList(),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.45,
                            child: TextFieldWidget(
                              title: '$title${unit != null ? ' ($unit)' : ''}',
                              controller: textController,
                              required: true,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return '$title es requerido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: ranges.map((range) => VitalSignRadio(
                                label: range.label,
                                color: range.color,
                                range: range.range,
                                displayText: range.displayText,
                                selected: selectedValue.value == range.label,
                                onTap: () {
                                  selectedValue.value = range.label;
                                  textController.text = range.displayText;
                                },
                              )).toList(),
                            ),
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}