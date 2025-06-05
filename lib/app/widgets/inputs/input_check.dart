import 'package:flutter/material.dart';

class InputCheck extends StatelessWidget {
  const InputCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width     : 20,
      height    : 20,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(232, 230, 238, 1)),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: const Icon(Icons.check, color: Colors.black, size: 15),
    );
  }
}