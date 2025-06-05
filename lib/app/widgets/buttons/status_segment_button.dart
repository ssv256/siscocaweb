import 'package:flutter/material.dart';

class StatusSegmentedButton extends StatelessWidget {
  final int value;
  final Function(int) onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final String? label;

  const StatusSegmentedButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = activeColor ?? theme.primaryColor;
    final errorColor = inactiveColor ?? Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        SegmentedButton<int>(
          segments: const [
            ButtonSegment<int>(
              value: 1,
              label: Text('Activo'),
              icon: Icon(Icons.check_circle_outline),
            ),
            ButtonSegment<int>(
              value: 0,
              label: Text('Inactivo'),
              icon: Icon(Icons.cancel_outlined),
            ),
          ],
          selected: {value},
          onSelectionChanged: (newSelection) => onChanged(newSelection.first),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return value == 1 
                    ? primaryColor.withOpacity(0.1)
                    : errorColor.withOpacity(0.1);
              }
              return null;
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return value == 1 ? primaryColor : errorColor;
              }
              return Colors.black87;
            }),
            side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
              if (states.contains(WidgetState.selected)) {
                return BorderSide(
                  color: value == 1 ? primaryColor : errorColor,
                  width: 1,
                );
              }
              return const BorderSide(
                color: Color.fromARGB(139, 10, 9, 9),
                width: 1,
              );
            }),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}