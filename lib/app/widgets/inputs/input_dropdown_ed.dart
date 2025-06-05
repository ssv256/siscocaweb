import 'package:flutter/material.dart';
import '../modals/help_modal.dart';

class InputDropDownEd extends StatelessWidget {
  final double width;
  final String title;
  final bool showTitle;
  final List<String> items;
  final String? value;
  final dynamic onChage;
  final bool error;
  final String helpTitle;
  final String helpContent;

  const InputDropDownEd({
    super.key,
    this.width = 300,
    this.showTitle = true,
    this.title = 'Selecciona una opción',
    this.items = const ['Masculino', 'Femenino'],
    this.error = false,
    this.helpTitle = '',
    this.helpContent = '',
    required this.onChage,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Asegurarnos de que value sea null si está vacío
    final currentValue = (value?.isEmpty ?? true) ? null : value;
    
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(showTitle)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title, 
                  style: const TextStyle(fontSize: 16, color: Colors.black)
                ),
                if(helpTitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: HelpInformation(
                      title: helpTitle,
                      body: helpContent
                    )
                  )
              ]
            ),
          const SizedBox(height: 4),
          Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: error ? Colors.red : Colors.black54, 
                width: .5
              )
            ),
            child: SizedBox(
              height: 40,
              child: DropdownButton<String>(
                hint: const Text('Selecciona una opción'),
                value: currentValue,
                onChanged: onChage,
                borderRadius: BorderRadius.circular(5),
                underline: Container(),
                padding: const EdgeInsets.only(top: 10, left: 10),
                isExpanded: true,
                iconEnabledColor: Colors.black,
                dropdownColor: Colors.white,
                items: [
                  // Opcional: añadir un item vacío si lo necesitas
                  /*DropdownMenuItem<String>(
                    value: '',
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.only(bottom: 10),
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black12, width: 1)
                        )
                      ),
                      child: const Text(
                        'Selecciona una opción',
                        style: TextStyle(fontSize: 14, color: Colors.black54)
                      ),
                    )
                  ),*/
                  ...items.map<DropdownMenuItem<String>>((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black12, width: 1)
                          )
                        ),
                        child: Text(
                          item, 
                          style: const TextStyle(fontSize: 14, color: Colors.black54)
                        ),
                      )
                    );
                  })
                ]
              )
            )
          )
        ]
      )
    );
  }
}