import 'package:flutter/material.dart';
import 'package:siscoca/app/modules/surveys/surveys_response/widget/index.dart';

class QuestionResponseBuilder extends StatelessWidget {
  final String questionId;
  final Map<String, dynamic> results;

  const QuestionResponseBuilder({
    super.key,
    required this.questionId,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final questionData = results[questionId] as Map<String, dynamic>?;
      if (questionData == null) {
        throw Exception('Datos de pregunta no encontrados');
      }

      final answerFormat = questionData['answerFormat'] as Map<String, dynamic>?;
      if (answerFormat == null) {
        throw Exception('Formato de respuesta no encontrado');
      }

      final questionType = answerFormat['questionType'] as String?;
      if (questionType == null) {
        throw Exception('Tipo de pregunta no encontrado');
      }

      final questionTitle = questionData['questionTitle'] as String? ?? 'Pregunta sin título';
      final resultsData = questionData['results'] as Map<String, dynamic>?;
      
      if (resultsData == null) {
        throw Exception('Datos de respuesta no encontrados');
      }

      return _buildResponseWidget(
        questionType: questionType,
        questionTitle: questionTitle,
        answerFormat: answerFormat,
        resultsData: resultsData,
      );
    } catch (e) {
      debugPrint('Error al procesar pregunta $questionId: $e');
      return ErrorQuestionWidget(identifier: questionId);
    }
  }

  Widget _buildResponseWidget({
    required String questionType,
    required String questionTitle,
    required Map<String, dynamic> answerFormat,
    required Map<String, dynamic> resultsData,
  }) {
    switch (questionType) {
      case 'Text':
        return TextResponseWidget(
          question: questionTitle,
          answer: resultsData['answer']?.toString() ?? 'Sin respuesta',
        );

      case 'SingleChoice':
        return ChoiceResponseWidget(
          question: questionTitle,
          answerFormat: answerFormat,
          results: resultsData,
          type: 'Radio',
        );

      case 'MultipleChoice':
        return ChoiceResponseWidget(
          question: questionTitle,
          answerFormat: answerFormat,
          results: resultsData,
          type: 'Selección multiple',
        );

      case 'Double':
        final suffix = answerFormat['suffix'] as String? ?? '';
        return TextResponseWidget(
          question: questionTitle,
          answer: '${resultsData['answer']?.toString() ?? '0'}$suffix',
        );

      case 'Scale':
        final prefix = answerFormat['prefix'] as String? ?? '';
        final suffix = answerFormat['suffix'] as String? ?? '';
        return TextResponseWidget(
          question: questionTitle,
          answer: '$prefix ${resultsData['answer']?.toString() ?? '0'} $suffix',
        );

      default:
        return ErrorQuestionWidget(identifier: questionTitle);
    }
  }
}