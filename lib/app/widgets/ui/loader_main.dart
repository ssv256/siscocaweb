import 'package:flutter/material.dart';

class LoaderMain extends StatelessWidget {
  final String title;

  const LoaderMain({
    super.key,
    this.title = 'Cargando Datos'
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child : Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
        child : Column(
          children  : [
            const CircularProgressIndicator(),
            const SizedBox(height: 15),
            Text(title, style :Theme.of(context).textTheme.bodyLarge)
          ]
        )
      )
    );
  }
}