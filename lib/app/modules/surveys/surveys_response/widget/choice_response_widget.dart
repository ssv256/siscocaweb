import 'package:flutter/material.dart';
import 'package:siscoca/app/modules/surveys/surveys_response/widget/index.dart';

class ChoiceResponseWidget extends StatelessWidget {
  final String question;
  final Map<String, dynamic> answerFormat;
  final Map<String, dynamic> results;
  final String type;

  const ChoiceResponseWidget({
    super.key,
    required this.question,
    required this.answerFormat,
    required this.results,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final choices = (answerFormat['choices'] as List).cast<Map<String, dynamic>>();
    final selectedAnswers = (results['answer'] as List).cast<Map<String, dynamic>>();
    final selectedValues = selectedAnswers.map((a) => a['value']).toList();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              QuestionTypeLabel(type: type),
            ],
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: choices.length,
            itemBuilder: (context, index) {
              final choice = choices[index];
              final isSelected = selectedValues.contains(choice['value']);
              
              return ChoiceOptionItem(
                choice: choice,
                isSelected: isSelected,
              );
            },
          ),
        ],
      ),
    );
  }
}
