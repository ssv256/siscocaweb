import 'package:flutter/material.dart';

class EmptyGeneral extends StatelessWidget {

  final IconData icon;
  final String text;

  const EmptyGeneral({
    super.key,
      this.icon = Icons.hourglass_empty_rounded,
      this.text = 'No hay datos para mostrar'
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.grey.withOpacity(.3)),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(color: Colors.grey, fontSize: 20), textAlign: TextAlign.center)
        ],
      ),
    );
  }
}