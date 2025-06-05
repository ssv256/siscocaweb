import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/surveys/surveys_create/controllers/ext_instructions_controller.dart';
import 'package:siscoca/app/widgets/inputs/main_input.dart';
import '../../../../widgets/buttons/ed_button.dart';
import '../../../../widgets/inputs/input_area.dart';
import '../controllers/surveys_create_controller.dart';

class SurveyInstructionModal extends GetView<SurveysCreateController> {
  const SurveyInstructionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Instrucciones de la encuesta'),
          const Spacer(),
          EdButton(
            textColor: Colors.white,
            bgColor: Colors.red[200],
            text: 'Cancelar',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 10),
          EdButton(
            textColor: Colors.white,
            bgColor: Theme.of(context).primaryColor,
            text: 'Guardar',
            onTap: () {
              if (controller.validateInstructionStep()) {
                controller.saveInstructionStep();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.7,
        child: ListView(
          children: [
            TextFieldWidget(
              title: 'Título*',
              controller: controller.textFieldController('instructionTitle'),
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              title: 'Texto detallado*',
              controller: controller.textFieldController('instructionDetailText'),
            ),
            const SizedBox(height: 20),
            InputAreaEd(
              title: 'Descripción',
              controller: controller.textFieldController('instructionText'),
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              title: 'Nota al pie',
              controller: controller.textFieldController('instructionFootnote'),
            ),
          ],
        ),
      ),
    );
  }
}
