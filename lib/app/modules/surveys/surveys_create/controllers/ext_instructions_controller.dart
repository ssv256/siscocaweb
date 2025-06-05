import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:research_package/research_package.dart';
import 'package:siscoca/app/modules/surveys/index.dart';

extension SurveyCreateInstructions on SurveysCreateController {
  bool validateInstructionStep() {
    if (textFieldController('instructionTitle').text.isEmpty) {
      Get.snackbar(
        'Error',
        'El título es requerido',
        backgroundColor: Colors.red[100],
      );
      return false;
    }

    if (textFieldController('instructionDetailText').text.isEmpty) {
      Get.snackbar(
        'Error',
        'El texto detallado es requerido',
        backgroundColor: Colors.red[100],
      );
      return false;
    }

    return true;
  }

  void saveInstructionStep() {
    final instructionStep = RPInstructionStep(
      identifier: 'instruction_${DateTime.now().millisecondsSinceEpoch}',
      title: textFieldController('instructionTitle').text,
      detailText: textFieldController('instructionDetailText').text,
      text: textFieldController('instructionText').text.isEmpty
          ? null
          : textFieldController('instructionText').text,
      footnote: textFieldController('instructionFootnote').text.isEmpty
          ? null
          : textFieldController('instructionFootnote').text,
      imagePath: textFieldController('instructionImagePath').text.isEmpty
          ? null
          : textFieldController('instructionImagePath').text,
    );

    // Get current steps and add instruction at the beginning
    final currentSteps = surveySelected.value.steps;
    
    // Remove any existing instruction step if present
    currentSteps.removeWhere((step) => step is RPInstructionStep);
    
    // Add the new instruction step at the beginning
    currentSteps.insert(0, instructionStep);
    
    // Update the survey
    surveySelected.value = RPOrderedTask(
      identifier: surveySelected.value.identifier,
      steps: currentSteps,
    );
  }

  void editInstructionStep(RPInstructionStep step) {
    textFieldController('instructionTitle').text = step.title;
    textFieldController('instructionDetailText').text = step.detailText ?? '';
    textFieldController('instructionText').text = step.text ?? '';
    textFieldController('instructionFootnote').text = step.footnote ?? '';
    textFieldController('instructionImagePath').text = step.imagePath ?? '';
  }
}