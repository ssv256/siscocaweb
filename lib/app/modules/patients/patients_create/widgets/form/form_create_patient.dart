import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';
import '../../../../../widgets/inputs/input_dropdown_ed.dart';
import '../../../../../widgets/inputs/main_input.dart';

/// Form widget for creating a new patient with personal and contact information
class FormCreatePatient extends GetView<PatientsCreateController> {
  const FormCreatePatient({super.key});

  static const Map<String, String> _genderOptions = {
    'M': 'Masculino',
    'F': 'Femenino'
  };

  String _getGenderLabel(String? code) {
    return code != null ? _genderOptions[code] ?? '' : '';
  }

  String _getGenderCode(String label) {
    return _genderOptions.entries
        .firstWhere((entry) => entry.value == label, 
                   orElse: () => const MapEntry('', ''))
        .key;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.patientFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldWidget(
            title: 'Nombre',
            controller: controller.nameController,
            required: true,
            validate: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre es requerido';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFieldWidget(
            title: 'Apellido',
            controller: controller.lastNameController,
            required: true,
            validate: (value) {
              if (value == null || value.isEmpty) {
                return 'El apellido es requerido';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          _buildResponsiveFields(),
          const SizedBox(height: 10),
          TextFieldWidget(
            title: 'Número de paciente',
            controller: controller.patientNumberController,
            required: true,
            validate: (value) {
              if (value == null || value.isEmpty) {
                return 'El número de paciente es requerido';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          _buildEmailFields(),
          const SizedBox(height: 30),
          FormSubmitButton(
            formKey: controller.patientFormKey,
            onSubmit: controller.validateAndContinue,
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;
        if (isWideScreen) {
          return IntrinsicHeight( 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: Obx(() => InputDropDownEd(
                      title: 'Sexo',
                      width: double.infinity,
                      value: _getGenderLabel(controller.selectedGender.value),
                      items: _genderOptions.values.toList(),
                      onChage: (value) => controller.updateGender(_getGenderCode(value)),
                      error: controller.genderError.value,
                    )),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldWidget(
                    title: 'Fecha de nacimiento',
                    controller: controller.birthDateController,
                    hintText: 'dd/MM/yyyy',
                    required: true,
                    helpTitle: 'Fecha de nacimiento',
                    helpContent: 'La fecha de nacimiento es necesaria para calcular la edad del paciente',
                    validate: controller.validateBirthDate
                  ),
                ),
              ],
            ),
          );
        } else {
          // For narrow screens, show fields in column
          return Column(
            children: [
              Obx(() => InputDropDownEd(
                title: 'Sexo',
                width: double.infinity,
                value: _getGenderLabel(controller.selectedGender.value),
                items: _genderOptions.values.toList(),
                onChage: (value) => controller.updateGender(_getGenderCode(value)),
                error: controller.genderError.value,
              )),
              const SizedBox(height: 10),
              TextFieldWidget(
                title: 'Fecha de nacimiento',
                controller: controller.birthDateController,
                hintText: 'dd/MM/yyyy',
                required: true,
                helpTitle: 'Fecha de nacimiento',
                helpContent: 'La fecha de nacimiento es necesaria para calcular la edad del paciente',
                validate: controller.validateBirthDate
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildEmailFields() {
    final confirmEmailController = TextEditingController();
    return Column(
      children: [
        TextFieldWidget(
          title: 'Email',
          controller: controller.emailController,
          required: true,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return 'El email es requerido';
            }
            if (!GetUtils.isEmail(value)) {
              return 'Ingresa un email válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          title: 'Confirmar Email',
          controller: confirmEmailController,
          required: true,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return 'La confirmación del email es requerida';
            }
            if (value != controller.emailController.text) {
              return 'Los correos no coinciden';
            }
            return null;
          },
        ),
      ],
    );
  }
}