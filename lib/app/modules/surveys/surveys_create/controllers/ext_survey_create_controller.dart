import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:research_package/model.dart';
import 'package:siscoca/app/modules/surveys/index.dart';

extension SurveyCreateQuestions on SurveysCreateController  {

  bool validateQuestion() {
    // Validación básica del título
    if (textFieldController('questionQuestion').text.isEmpty) {
      Get.snackbar('Error', 'La pregunta es requerida',
        backgroundColor: Colors.red[100]);
      return false;
    }

    // Validaciones específicas por tipo
    switch (questionType.value) {
      case 'Radio':
        // Validar que haya al menos 2 opciones
        if (questionOptions.length < 2) {
          Get.snackbar('Error', 'Se requieren al menos 2 opciones para pregunta tipo Radio',
            backgroundColor: Colors.red[100]);
          return false;
        }
        // Validar que todas las opciones tengan texto
        for (var option in questionOptions) {
          if (textFieldController('option${option['id']}').text.isEmpty) {
            Get.snackbar('Error', 'Todas las opciones deben tener texto',
              backgroundColor: Colors.red[100]);
            return false;
          }
        }
        break;
        
      case 'Slider':
        if (textFieldController('sliderMin').text.isEmpty ||
            textFieldController('sliderMax').text.isEmpty ||
            textFieldController('sliderDivisions').text.isEmpty) {
          Get.snackbar('Error', 'Todos los campos del slider son requeridos',
            backgroundColor: Colors.red[100]);
          return false;
        }
        break;
        
      case 'Numeros':
        if (textFieldController('integerMin').text.isEmpty ||
            textFieldController('integerMax').text.isEmpty) {
          Get.snackbar('Error', 'Los valores mínimo y máximo son requeridos',
            backgroundColor: Colors.red[100]);
          return false;
        }
        break;
    }
    return true;
  }

  void addDefaultOptions() {
    if (questionOptions.isEmpty) {
      // Add two default options
      addQuestionOption();
      addQuestionOption();
    }
  }

  void addQuestionOption() {
    // Add only one option at a time
    var id = DateTime.now().millisecondsSinceEpoch;
    questionOptions.add({
      'id': id,
      'title': '',
    });
  }

  void removeQuestionOption(int id) {
    questionOptions.removeWhere((element) => element['id'] == id);
  }

  void setStepToEdit(RPStep step) {
    stepToEdit.value = step;
    
    if (step is RPQuestionStep) {
      final questionStep = step;
      textFieldController('questionQuestion').text = questionStep.title;
      final format = questionStep.answerFormat;
      
      if (format is RPChoiceAnswerFormat) {
        questionType.value = 'Radio';
        isMultipleChoice.value = format.answerStyle == RPChoiceAnswerStyle.MultipleChoice;
        
        // Configurar las opciones
        questionOptions.clear();
        for (int i = 0; i < format.choices.length; i++) {
          final choice = format.choices[i];
          final id = DateTime.now().millisecondsSinceEpoch + i;
          questionOptions.add({'id': id});

          final controller = TextEditingController(text: choice.text);
          textControllers['option$id'] = controller;
        }
      } 
      else if (format is RPSliderAnswerFormat) {
        questionType.value = 'Slider';
        textFieldController('sliderMin').text = format.minValue.toString();
        textFieldController('sliderMax').text = format.maxValue.toString();
        textFieldController('sliderDivisions').text = format.divisions.toString();
        textFieldController('sliderPrefix').text = format.prefix ?? '';
        textFieldController('sliderSuffix').text = format.suffix ?? '';
      }
      else if (format is RPDoubleAnswerFormat) {
        questionType.value = 'Numeros';
        textFieldController('integerMin').text = format.minValue.toString();
        textFieldController('integerMax').text = format.maxValue.toString();
        textFieldController('integerSuffix').text = format.suffix ?? '';
      }
      else if (format is RPTextAnswerFormat) {
        questionType.value = 'Text';
        textFieldController('textHint').text = format.hintText ?? '';
      }
    }
    if (step is RPInstructionStep) {
      final instructionStep = step;
      textFieldController('instructionTitle').text = instructionStep.title;
      textFieldController('instructionDetailText').text = instructionStep.detailText ?? '';
      textFieldController('instructionText').text = instructionStep.text ?? '';
      textFieldController('instructionFootnote').text = instructionStep.footnote ?? '';
    } 
    else if (step is RPCompletionStep) {
      final completionStep = step ;
      textFieldController('completionTitle').text = completionStep.title;
      textFieldController('completionText').text = completionStep.text ?? '';
    }
  }

  void initNewQuestion() {
    // Clear any previous data
    clearEditMode();
    
    // Set default values for slider
    textFieldController('sliderMin').text = '0';
    textFieldController('sliderMax').text = '100';
    textFieldController('sliderDivisions').text = '10';
    
    // Set default values for number input
    textFieldController('integerMin').text = '0';
    textFieldController('integerMax').text = '100';
    
    // Add default options for Radio
    if (questionOptions.isEmpty) {
      addQuestionOption();
      addQuestionOption();
    }
  }

  void clearEditMode() {
    stepToEdit.value = null;
    questionType.value = 'Radio';
    isMultipleChoice.value = false;
    questionOptions.clear();
    
    // Clear all form fields
    textFieldController('questionQuestion').text = '';
    
    // Clear Radio options
    for (var option in questionOptions) {
      textFieldController('option${option['id']}').text = '';
    }
    
    // Clear Slider fields
    textFieldController('sliderMin').text = '';
    textFieldController('sliderMax').text = '';
    textFieldController('sliderDivisions').text = '';
    textFieldController('sliderPrefix').text = '';
    textFieldController('sliderSuffix').text = '';
    
    // Clear Number fields
    textFieldController('integerMin').text = '';
    textFieldController('integerMax').text = '';
    textFieldController('integerSuffix').text = '';
    
    // Clear Text field
    textFieldController('textHint').text = '';
    
    // Add default options for Radio type
    addDefaultOptions();
  }

  void saveQuestion() {
    if (!validateQuestion()) return;

    final identifier = stepToEdit.value?.identifier ?? "question_${DateTime.now().millisecondsSinceEpoch}";
    final title = textFieldController('questionQuestion').text;
    RPQuestionStep newStep;

    switch (questionType.value) {
      case 'Radio':
        List<RPChoice> choices = [];
        for (var option in questionOptions) {
          choices.add(RPChoice(
            text: textFieldController('option${option['id']}').text,
            value: option['id'],
          ));
        }
        
        newStep = RPQuestionStep(
          identifier: identifier,
          title: title,
          answerFormat: RPChoiceAnswerFormat(
            answerStyle: isMultipleChoice.value 
              ? RPChoiceAnswerStyle.MultipleChoice 
              : RPChoiceAnswerStyle.SingleChoice,
            choices: choices,
          ),
        );
        break;

      case 'Slider':
        newStep = RPQuestionStep(
          identifier: identifier,
          title: title,
          answerFormat: RPSliderAnswerFormat(
            minValue: double.parse(textFieldController('sliderMin').text),
            maxValue: double.parse(textFieldController('sliderMax').text),
            divisions: int.parse(textFieldController('sliderDivisions').text),
            prefix: textFieldController('sliderPrefix').text,
            suffix: textFieldController('sliderSuffix').text,
          ),
        );
        break;

      case 'Numeros':
        newStep = RPQuestionStep(
          identifier: identifier,
          title: title,
          answerFormat: RPDoubleAnswerFormat(
            minValue: double.parse(textFieldController('integerMin').text),
            maxValue: double.parse(textFieldController('integerMax').text),
            suffix: textFieldController('integerSuffix').text,
          ),
        );
        break;

      case 'Text':
        newStep = RPQuestionStep(
          identifier: identifier,
          title: title,
          answerFormat: RPTextAnswerFormat(
            hintText: textFieldController('textHint').text,
          ),
        );
        break;

      default:
        return;
    }

    // Si estamos editando, actualizar el paso existente
    if (stepToEdit.value != null) {
      final steps = surveySelected.value.steps;
      final index = steps.indexWhere((step) => step.identifier == stepToEdit.value!.identifier);
      if (index != -1) {
        steps[index] = newStep;
        surveySelected.value = RPOrderedTask(
          identifier: surveySelected.value.identifier,
          steps: steps,
        );
      }
    } else {
      // Si es nuevo, añadirlo al final
      final steps = surveySelected.value.steps;
      steps.add(newStep);
      surveySelected.value = RPOrderedTask(
        identifier: surveySelected.value.identifier,
        steps: steps,
      );
    }
    
    // Force UI update by triggering a refresh
    surveySelected.refresh();
    
    // Show success message
    Get.snackbar(
      'Éxito',
      stepToEdit.value != null ? 'Pregunta actualizada correctamente' : 'Pregunta añadida correctamente',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green[800],
      duration: const Duration(seconds: 2),
    );
  }

  void removeStep(RPStep step) {
    final currentSteps = [...surveySelected.value.steps];
    currentSteps.removeWhere((s) => s.identifier == step.identifier);
    surveySelected.value = RPOrderedTask(
      identifier: surveySelected.value.identifier,
      steps: currentSteps
    );
  }

  bool validateCompletionStep() {
    if (textFieldController('completionTitle').text.isEmpty) {
      Get.snackbar('Error', 'El título es requerido',
        backgroundColor: Colors.red[100]);
      return false;
    }
    if (textFieldController('completionText').text.isEmpty) {
      Get.snackbar('Error', 'El texto de agradecimiento es requerido',
        backgroundColor: Colors.red[100]);
      return false;
    }
    return true;
  }

  void saveCompletionStep() {
    final steps = surveySelected.value.steps;
    final completionStep = RPCompletionStep(
      identifier: stepToEdit.value?.identifier ?? 'completion_${DateTime.now().millisecondsSinceEpoch}',
      title: textFieldController('completionTitle').text,
      text: textFieldController('completionText').text,
    );

    if (stepToEdit.value != null) {
      final index = steps.indexWhere((step) => step.identifier == stepToEdit.value!.identifier);
      if (index != -1) {
        steps[index] = completionStep;
      }
    }

    surveySelected.value = RPOrderedTask(
      identifier: surveySelected.value.identifier,
      steps: steps,
    );
    clearEditMode();
  }

  void ensureInstructionStep() {
    final steps = surveySelected.value.steps;
    final instructionStepIndex = steps.indexWhere((step) => step is RPInstructionStep);
    final instructionStep = RPInstructionStep(
      identifier: 'instruction_${DateTime.now().millisecondsSinceEpoch}',
      title: textFieldController('title').text,
      text: textFieldController('description').text,
      detailText: textFieldController('advertencia').text,
    );

    if (instructionStepIndex != -1) {
      // Si existe y no es el primero, reordenarlo
      if (instructionStepIndex != 0) {
        steps.removeAt(instructionStepIndex);
        steps.insert(0, instructionStep);
      }
    } else {
      steps.insert(0, instructionStep);
    }
    surveySelected.value = RPOrderedTask(
      identifier: surveySelected.value.identifier,
      steps: steps,
    );
  }


  void ensureCompletionStep() {
    final steps = surveySelected.value.steps;
    final completionStepIndex = steps.indexWhere((step) => step is RPCompletionStep);

    if (completionStepIndex != -1) {
      final existingStep = steps[completionStepIndex] as RPCompletionStep;
      if (completionStepIndex != steps.length - 1) {
        steps.removeAt(completionStepIndex);
        steps.add(existingStep);
      }
    } else {
      final completionStep = RPCompletionStep(
        identifier: 'completion_${DateTime.now().millisecondsSinceEpoch}',
        title: "Terminado!!!",
        text: "Gracias por contestar las preguntas!",
      );
      steps.add(completionStep);
    }

    surveySelected.value = RPOrderedTask(
      identifier: surveySelected.value.identifier,
      steps: steps,
    );
  }
}