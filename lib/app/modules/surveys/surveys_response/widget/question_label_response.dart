import 'package:flutter/material.dart';

class QuestionTypeLabel extends StatelessWidget {
  final String type;

  const QuestionTypeLabel({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case 'Radio':
        color = const Color.fromARGB(32, 76, 175, 79);
        break;
      case 'Texto':
        color = const Color.fromARGB(32, 255, 0, 0);
        break;
      case 'Selección multiple':
        color = const Color.fromARGB(32, 0, 0, 255);
        break;
      default:
        color = Colors.grey.withOpacity(0.3);
    }

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        type,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }
}