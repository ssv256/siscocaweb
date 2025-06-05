import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/studies_admin/index.dart';
import 'package:siscoca/app/widgets/buttons/ed_button.dart';
import '../../../../widgets/inputs/main_input.dart';

class EstudiesForm extends GetView<StudyAdminCreateController> {
  const EstudiesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldWidget(
            id: 'studyName',
            controller: controller.studyNameController,
            labelText: 'Titulo',
            required: true,
          ),
          TextFieldWidget(
            id: 'description',
            controller: controller.descriptionController,
            labelText: 'Descripción',
            required: true,
          ),
          TextFieldWidget(
            id: 'hospital',
            controller: controller.hospitalController,
            labelText: 'Hospital',
            required: true,
          ),
          TextFieldWidget(
            id: 'responsiblePerson',
            controller: controller.responsiblePersonController,
            labelText: 'Responsable',
            required: true,
          ),
          TextFieldWidget(
            id: 'email',
            controller: controller.emailController,
            labelText: 'Correo',
            required: true,
          ),
          TextFieldWidget(
            id: 'phone',
            controller: controller.phoneController,
            labelText: 'Teléfono',
            required: true,
          ),
          TextFieldWidget(
            id: 'additionalData',
            controller: controller.additionalDataController,
            labelText: 'Datos Adicionales',
            required: false,
          ),
          const SizedBox(height: 16),
          
          // Status Selection with _FormSection and SegmentedButton
          _FormSection(
            title: 'Estado',
            showDivider: false,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment<int>(
                          value: 1,
                          label: Text('Activo'),
                        ),
                        ButtonSegment<int>(
                          value: 0,
                          label: Text('Inactivo'),
                        ),
                      ],
                      selected: {controller.status.value},
                      onSelectionChanged: (Set<int> newSelection) {
                        controller.updateStatus(newSelection.first);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : EdButton(
                  width: double.infinity,
                  textColor: Colors.white,
                  bgColor: Theme.of(context).primaryColor,
                  text: controller.isEdit.value ? 'Actualizar' : 'Guardar',
                  onTap: () => controller.checkForm(),
                ),
        ],
      ),
    ));
  }
}

// FormSection widget implementation
class _FormSection extends StatelessWidget {
  final String title;
  final bool showDivider;
  final List<Widget> children;

  const _FormSection({
    required this.title,
    this.showDivider = true,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDivider) const Divider(),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}