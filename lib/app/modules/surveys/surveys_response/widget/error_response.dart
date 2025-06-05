import 'package:flutter/material.dart';

class ErrorQuestionWidget extends StatelessWidget {
  final dynamic identifier;

  const ErrorQuestionWidget({
    super.key,
    required this.identifier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(15),
        color: Colors.red.withOpacity(0.1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Error al cargar pregunta ${identifier.toString()}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}