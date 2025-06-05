import 'package:flutter/material.dart';

class DateRangeDropdown extends StatelessWidget {
  final int selectedDays;
  final Function(int) onDaysChanged;

  const DateRangeDropdown({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
  });

  final List<Map<String, dynamic>> _dateRanges = const [
    {'label': 'Un mes', 'days': 30},
    {'label': '3 meses', 'days': 90},
    {'label': '6 meses', 'days': 180},
  ];

  @override
  Widget build(BuildContext context) {
    String selectedLabel = _dateRanges
        .firstWhere((range) => range['days'] == selectedDays)['label'] as String;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButton<int>(
        value: selectedDays,
        isExpanded: true,
        underline: Container(),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          size: 20,
          color: Color(0xFF718096),
        ),
        items: _dateRanges.map((range) {
          return DropdownMenuItem<int>(
            value: range['days'] as int,
            child: 
              Text(
                range['label'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2D3748),
                ),
              )
            );
          }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return _dateRanges.map((range) {
            return Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Color(0xFF718096),
                ),
                const SizedBox(width: 8),
                Text(
                  selectedLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            );
          }).toList();
        },
        onChanged: (int? value) {
          if (value != null) {
            onDaysChanged(value);
          }
        },
      ),
    );
  }
}