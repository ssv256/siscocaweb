import 'package:flutter/material.dart';
import 'package:siscoca/app/widgets/inputs/main_input.dart';

import '../buttons/ed_icon_button.dart';

class InputWithDropdown extends StatelessWidget {
  final dynamic controller;
  final List<String> items;
  final String value;
  final dynamic onTap;
  final bool error;
  final String title;

  const InputWithDropdown({
    super.key,
    this.items = const [],
    this.value = '',
    this.error = false,
    this.title = '',
    required this.controller,
    required this.onTap,

  });

  item(a, context){
    return InkWell(
      onTap: (){
        onTap(a);
        controller.text = a;
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        margin    : const EdgeInsets.only(bottom: 10),
        padding   : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color       : Colors.grey[200],
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text(a),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            title       : title,
            controller : controller,
            required    : true,
          )
        ),
        const SizedBox(width: 20),
        Container(
          margin: const EdgeInsets.only(top: 45),
          child: EdIconBtn(
            bg    : true,
            color : Theme.of(context).primaryColor,
            icon  : Icons.add,
            onTap : (){
              showDialog(
                context: context, 
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor : Colors.white,
                    content         : SizedBox(
                      height          : 450,
                      child           : Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment : MainAxisAlignment.spaceBetween,
                            children          : [
                              const Text('Agregar Peso', style: TextStyle(fontSize: 20, color: Colors.black)),
                              EdIconBtn(
                                icon  : Icons.close,
                                color : Colors.red,
                                onTap : (){
                                }
                              )
                            ]
                          ),
                          const SizedBox(height: 5),
                          const Divider(),
                          
                          //Opciones de peso
                          for (var a in items)
                            item(a, context),
                        ]
                      )
                    )
                  );
                }
              );
            }
          ),
        )
      ]
    );
  }
}