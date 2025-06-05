import 'package:flutter/material.dart';
import 'package:siscoca/app/widgets/inputs/radio_buttom.dart';

class VitalSignRadio extends StatelessWidget {
  final String label;
  final Color color;
  final String range;
  final String displayText;
  final bool selected;
  final VoidCallback onTap;

  const VitalSignRadio({
    super.key,
    required this.label,
    required this.color,
    required this.range,
    required this.displayText,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioButtom(
          value: label,
          selected: selected,
          widthColor: color,
          onTap: onTap,
        ),
        const SizedBox(width: 8),
        Text(
          range,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class VitalSignRange {
  final String label;
  final Color color;
  final String range;
  final double? minValue;
  final double? maxValue;
  final String displayText;

  const VitalSignRange({
    required this.label,
    required this.color,
    required this.range,
    this.minValue,
    this.maxValue,
    required this.displayText,
  });

  bool isInRange(double value) {
    if (minValue != null && maxValue != null) {
      return value >= minValue! && value <= maxValue!;
    } else if (minValue != null) {
      return value >= minValue!;
    } else if (maxValue != null) {
      return value <= maxValue!;
    }
    return false;
  }
}