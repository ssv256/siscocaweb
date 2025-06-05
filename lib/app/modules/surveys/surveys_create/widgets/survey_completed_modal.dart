import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/surveys/surveys_create/controllers/ext_survey_create_controller.dart';
import 'package:siscoca/app/modules/surveys/surveys_create/controllers/surveys_create_controller.dart';
import 'package:siscoca/app/widgets/buttons/ed_button.dart';
import 'package:siscoca/app/widgets/inputs/input_area.dart';
import 'package:siscoca/app/widgets/inputs/main_input.dart';

class SurveyCompletionModal extends GetView<SurveysCreateController> {
  const SurveyCompletionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Paso de finalización'),
          const Spacer(),
          EdButton(
            textColor: Colors.white,
            bgColor: Colors.red[200],
            text: 'Cancelar',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          EdButton(
            textColor: Colors.white,
            bgColor: Theme.of(context).primaryColor,
            text: 'Guardar',
            onTap: () {
              if (controller.validateCompletionStep()) {
                controller.saveCompletionStep();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView(
          children: [
            TextFieldWidget(
              title: 'Título*',
              controller: controller.textFieldController('completionTitle'),
            ),
            const SizedBox(height: 20),
            InputAreaEd(
              title: 'Texto de agradecimiento*',
              controller: controller.textFieldController('completionText'),
            ),
          ],
        ),
      ),
    );
  }
}