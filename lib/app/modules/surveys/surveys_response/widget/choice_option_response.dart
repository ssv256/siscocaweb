import 'package:flutter/material.dart';

class ChoiceOptionItem extends StatelessWidget {
  final Map<String, dynamic> choice;
  final bool isSelected;

  const ChoiceOptionItem({
    super.key,
    required this.choice,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected 
          ? const Color.fromARGB(51, 137, 238, 130)
          : Colors.white,
        border: Border.all(
          color: isSelected 
            ? const Color.fromARGB(255, 76, 175, 79)
            : Colors.black.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected 
              ? const Color.fromARGB(255, 76, 175, 79)
              : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              choice['text'] as String,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}