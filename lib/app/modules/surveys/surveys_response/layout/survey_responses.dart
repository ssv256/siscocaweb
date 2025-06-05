import 'package:flutter/material.dart';
import 'package:domain/models/task/index.dart';
import 'package:health/health.dart';
import 'package:siscoca/app/modules/surveys/surveys_response/widget/index.dart';

class SurveyResponseDesktop extends StatelessWidget {
  final dynamic value;
  
  const SurveyResponseDesktop({
    super.key,
    required this.value,
  });
@override
  Widget build(BuildContext context) {
    try {
      Map<String, dynamic>? results;
      
      if (value is SymptomsHealthValue) {
        final symptomData = value.symptom;
        if (symptomData['__type'] == 'RPTaskResult') {
          results = symptomData['results'] as Map<String, dynamic>?;
        }
      } else if (value is TaskResponseDetails && value is SurveyTaskResponseDetails) {
        results = (value as SurveyTaskResponseDetails).answers['results'] as Map<String, dynamic>?;
      }

      if (results == null || results.isEmpty) {
        return const Center(child: Text('No hay respuestas disponibles'));
      }

      return AlertDialog(
        backgroundColor: Colors.white,
        title: const _DialogHeader(),
        content: _DialogContent(results: results),
      );
    } catch (e) {
      debugPrint('Error al cargar los síntomas: $e');
      return const Center(child: Text('Error al cargar los síntomas'));
    }
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Resultados de Síntomas'),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}

class _DialogContent extends StatelessWidget {
  final Map<String, dynamic> results;
  
  const _DialogContent({
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              try {
                final questionId = results.keys.elementAt(index);
                return QuestionResponseBuilder(
                  questionId: questionId,
                  results: results,
                );
              } catch (e) {
                debugPrint('Error al construir pregunta $index: $e');
                return ErrorQuestionWidget(identifier: index);
              }
            },
          ),
        ),
      ],
    );
  }
}