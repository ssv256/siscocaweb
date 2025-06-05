import 'package:flutter/material.dart';
import '../modals/help_modal.dart';

class MultiSelectDropDownEd extends StatelessWidget {
  final double width;
  final String title;
  final bool showTitle;
  final List<String> options;
  final List<String> values;
  final Function(List<String>) onChanged;
  final bool error;
  final String helpTitle;
  final String helpContent;

  const MultiSelectDropDownEd({
    super.key,
    this.width = 300,
    this.showTitle = true,
    required this.title,
    required this.options,
    required this.values,
    required this.onChanged,
    this.error = false,
    this.helpTitle = '',
    this.helpContent = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                if (helpTitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: HelpInformation(
                      title: helpTitle,
                      body: helpContent,
                    ),
                  )
              ],
            ),
          const SizedBox(height: 4),
          Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: error ? Colors.red : Colors.black54,
                width: .5,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                _showMultiSelect(context);
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: values.isEmpty
                          ? const Text(
                              'Selecciona opciones',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            )
                          : Text(
                              values.join(', '),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMultiSelect(BuildContext context) async {
    final List<String> selectedValues = List.from(values);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: options.map((option) {
                return CheckboxListTile(
                  title: Text(
                    option,
                    style: const TextStyle(fontSize: 14),
                  ),
                  value: selectedValues.contains(option),
                  onChanged: (bool? selected) {
                    if (selected == true) {
                      selectedValues.add(option);
                    } else {
                      selectedValues.remove(option);
                    }
                    (context as Element).markNeedsBuild();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                onChanged(selectedValues);
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}