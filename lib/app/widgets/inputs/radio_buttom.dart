import 'package:flutter/material.dart';

class RadioButtom extends StatelessWidget {

  final dynamic onTap;
  final String value;
  final bool selected;
  final dynamic widthColor;

  const RadioButtom({
    super.key,
    required this.onTap,
    required this.value,
    this.selected = false,
    this.widthColor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 36,
        child: Row(
          children: [
            Container(
              width     : 20,
              height    : 20,
              decoration: BoxDecoration(
                border      : Border.all(color: const Color.fromRGBO(232, 230, 238, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color       : selected ? const Color.fromRGBO(232, 230, 238, 1) : Colors.white,
              ),
              child: selected ? const Icon(Icons.check, color: Colors.black, size: 15) : null,
            ),
            if(widthColor != null)
              Container(
                width     : 5,
                height    : 20,
                margin: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color       : widthColor,
                ),
              ),
            const SizedBox(width: 5),
            Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ]
        )
      )
    );
  }
}