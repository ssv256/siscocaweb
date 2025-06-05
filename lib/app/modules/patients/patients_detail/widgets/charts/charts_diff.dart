import 'package:flutter/material.dart';

// symptomatology_placeholder.dart
class SymptomatologyPlaceholder extends StatelessWidget {
  const SymptomatologyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.healing_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Próximamente: Registro de Sintomatología',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}