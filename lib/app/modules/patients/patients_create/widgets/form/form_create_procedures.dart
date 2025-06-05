import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';
import 'package:siscoca/app/widgets/buttons/ed_button.dart';
import '../../../../../widgets/inputs/main_input.dart';

class FormProcedures extends GetView<PatientsCreateController> {
  const FormProcedures({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.proceduresFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProcedureFields(),
            _buildAddProcedureButton(context),
            const SizedBox(height: 30),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProcedureFields() {
  return Obx(() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(
      controller.procedureControllers.length,
      (index) => Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFieldWidget(
                  title: 'Procedimiento ${index + 1}',
                  controller: controller.procedureControllers[index],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => controller.removeProcedureField(index),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ));
}


  Widget _buildAddProcedureButton(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: InkWell(
        onTap: controller.addProcedureField,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Añadir nuevo procedimiento',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showEmptyProceduresDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('No has añadido procedimientos'),
        content: const Text(
            '¿Estás seguro de enviar el formulario sin añadir procedimientos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continuar sin procedimientos'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _buildSubmitButton(BuildContext context) {
    return EdButton(
      width: double.infinity,
      textColor: Colors.white,
      bgColor: Theme.of(context).primaryColor,
      text: 'Continuar',
      onTap: () async {
        if (!controller.proceduresFormKey.currentState!.validate()) {
          return;
        }
        if (controller.procedureControllers.isEmpty) {
          final shouldContinue = await _showEmptyProceduresDialog(context);
          if (!shouldContinue) return;
        }
        controller.saveAndContinueFromProcedures();
      },
    );
  }
}