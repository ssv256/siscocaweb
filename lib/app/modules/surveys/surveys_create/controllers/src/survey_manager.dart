import 'package:get/get.dart';
import 'package:research_package/research_package.dart';

class SurveyManager {
  final RxList<RPStep> _steps = <RPStep>[].obs;
  late Rx<RPOrderedTask> _task;
  

  void initializeTask({
    required String identifier,
    String title = '',
    String description = '',
    String instructions = '',
    String warnings = '',
  }) {
    _steps.clear();
    
    // Add instruction step if provided
    if (instructions.isNotEmpty) {
      _steps.add(RPInstructionStep(
        identifier: '${identifier}_instructions',
        title: title,
        text: instructions,
        detailText: description,
        footnote: warnings.isNotEmpty ? 'Warning: $warnings' : null,
      ));
    }

    _task = RPOrderedTask(
      identifier: identifier,
      steps: _steps,
    ).obs;
  }

  // Add an instruction step
  void addInstructionStep({
    required String identifier,
    required String title,
    String? detailText,
    String? text,
    String? footnote,
    String? imagePath,
  }) {
    _steps.add(RPInstructionStep(
      identifier: identifier,
      title: title,
      detailText: detailText,
      text: text,
      footnote: footnote,
      imagePath: imagePath,
    ));
    _updateTask();
  }

    // Add single choice question
  void addSingleChoice({
    required String identifier,
    required String title,
    required List<RPChoice> choices,
    bool optional = false,
  }) {
 
    _addQuestionStep(
      identifier: identifier,
      title: title,
      answerFormat: RPChoiceAnswerFormat(
        answerStyle: RPChoiceAnswerStyle.SingleChoice,
        choices: choices,
      ),
      optional: optional,
    );
  }

  // Add a multiple choice question
  void addMultipleChoiceQuestion({
    required String identifier,
    required String title,
    required List<RPChoice> choices,
    bool optional = false,
    String? footnote,
  }) {
    final answerFormat = RPChoiceAnswerFormat(
      answerStyle: RPChoiceAnswerStyle.MultipleChoice,
      choices: choices,
    );

    _steps.add(RPQuestionStep(
      identifier: identifier,
      title: title,
      answerFormat: answerFormat,
      optional: optional,
      footnote: footnote,
    ));
    _updateTask();
  }

  // Add a text input question
  void addTextQuestion({
    required String identifier,
    required String title,
    String hintText = '',
    bool optional = false,
    String? footnote,
  }) {
    final answerFormat = RPTextAnswerFormat(hintText: hintText);

    _steps.add(RPQuestionStep(
      identifier: identifier,
      title: title,
      answerFormat: answerFormat,
      optional: optional,
      footnote: footnote,
    ));
    _updateTask();
  }

  // Add a numeric input question (integer)
  void addIntegerQuestion({
    required String identifier,
    required String title,
    required int minValue,
    required int maxValue,
    String? suffix,
    bool optional = false,
    String? footnote,
  }) {
    final answerFormat = RPIntegerAnswerFormat(
      minValue: minValue,
      maxValue: maxValue,
      suffix: suffix,
    );

    _steps.add(RPQuestionStep(
      identifier: identifier,
      title: title,
      answerFormat: answerFormat,
      optional: optional,
      footnote: footnote,
    ));
    _updateTask();
  }

  // Add a date/time question
  void addDateTimeQuestion({
    required String identifier,
    required String title,
    required RPDateTimeAnswerStyle style,
    bool optional = false,
    String? footnote,
  }) {
    final answerFormat = RPDateTimeAnswerFormat(dateTimeAnswerStyle: style);

    _steps.add(RPQuestionStep(
      identifier: identifier,
      title: title,
      answerFormat: answerFormat,
      optional: optional,
      footnote: footnote,
    ));
    _updateTask();
  }

  // Add a form step (multiple questions on one screen)
  

  // Add a completion step
  void addCompletionStep({
    required String identifier,
    required String title,
    String? text,
  }) {
    _steps.add(RPCompletionStep(
      identifier: identifier,
      title: title,
      text: text,
    ));
    _updateTask();
  }


  // Add text input question
  void addTextInput({
    required String identifier,
    required String title,
    String hint = '',
    bool optional = false,
  }) {
    _addQuestionStep(
      identifier: identifier,
      title: title,
      answerFormat: RPTextAnswerFormat(hintText: hint),
      optional: optional,
    );
  }

  // Add numeric input
  void addNumericInput({
    required String identifier,
    required String title,
    required num min,
    required num max,
    String? suffix,
    bool isInteger = false,
    bool optional = false,
  }) {
    final format = isInteger
        ? RPIntegerAnswerFormat(
            minValue: min.toInt(),
            maxValue: max.toInt(),
            suffix: suffix,
          )
        : RPDoubleAnswerFormat(
            minValue: min.toDouble(),
            maxValue: max.toDouble(),
            suffix: suffix,
          );

    _addQuestionStep(
      identifier: identifier,
      title: title,
      answerFormat: format,
      optional: optional,
    );
  }

  // Helper to add question step
  void _addQuestionStep({
    required String identifier,
    required String title,
    required RPAnswerFormat answerFormat,
    bool optional = false,
  }) {
    _steps.add(RPQuestionStep(
      identifier: identifier,
      title: title,
      answerFormat: answerFormat,
      optional: optional,
    ));
    _updateTask();
  }

  // Add date/time question
  void addDateTime({
    required String identifier,
    required String title,
    required RPDateTimeAnswerStyle style,
    bool optional = false,
  }) {
    _addQuestionStep(
      identifier: identifier,
      title: title,
      answerFormat: RPDateTimeAnswerFormat(dateTimeAnswerStyle: style),
      optional: optional,
    );
  }

  // Add completion step
  void addCompletion({
    required String text,
    String title = 'Survey Complete',
  }) {
    _steps.add(RPCompletionStep(
      identifier: 'completion',
      title: title,
      text: text,
    ));
    _updateTask();
  }

  // Update task with current steps
  void _updateTask() {
    _task.value = RPOrderedTask(
      identifier: _task.value.identifier,
      steps: _steps.toList(),
    );
  }

  // Get the current task
  RPOrderedTask get task => _task.value;

  // Clear all steps
  void clear() {
    _steps.clear();
    _updateTask();
  }
}