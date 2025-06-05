import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldSimulator extends StatelessWidget {
  
  final String title;
  final String data;
  final dynamic action;
  final double height;
  final double paddingVertical;
  final dynamic clearAction;
  final double width;
  final bool error;


  const FieldSimulator({
    super.key,
    this.title            = 'Seleccionar',
    this.data             = 'Seleccionar',
    this.height           = 45,
    this.width            = 300,
    this.paddingVertical  = 10,
    this.clearAction,
    required this.action,
    this.error = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(title != '')
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Text(title, style: Get.textTheme.bodyLarge )
        ),
        const SizedBox(height: 5),
        Stack(
          children: [
            InkWell(
              splashColor   : Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor    : Colors.transparent,
              onTap         : action,
              child         : Container(
                padding     :  EdgeInsets.symmetric(vertical: paddingVertical, horizontal: 10),
                width         : width,
                height        : height,
                decoration    : BoxDecoration(
                  color       :  Colors.white,
                  borderRadius:  const BorderRadius.all(Radius.circular(7)),
                  border      :  Border.all(color: error ? Colors.red : Colors.black54, width: .5)
                ),
                child         : Text(data, style: Get.textTheme.bodyLarge!.copyWith(color: Colors.black)),
              )
            ),
            if(clearAction != null)
              Positioned(
                right: 15,
                top: 20,
                child: InkWell(
                  onTap: clearAction,
                  child: Icon(Icons.cleaning_services, color: Colors.grey.withOpacity(.5), size: 20)
                ),
              )
          ]
        )
      ]
    );
  }
}