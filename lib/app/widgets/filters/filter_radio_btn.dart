import 'package:flutter/material.dart';

class FilterRadioBtn extends StatelessWidget {
  final bool value;
  final String text;
  final dynamic onChanged;
  
  const FilterRadioBtn({
    super.key,
    this.value = false,
    required this.text,
    required this.onChanged

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width     : 25,
              height    : 25,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color       : Colors.white10,
                borderRadius: BorderRadius.circular(5),
                border      : Border.all(
                  color : value ? Colors.white : Colors.transparent,
                  width : 1
                )
              ),
              child: value ? const Icon(Icons.check, size: 15, color: Colors.white) : null,
            ),
            const SizedBox(width: 15),
            Text(text)
          ]
        )
      ),
    );
  }
}