import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CounterCard extends StatelessWidget {
  
  final IconData icon;
  final String title;
  final String data;
  final dynamic onTap;
  final bool lastWeek;
  final double? width;
  
  const CounterCard({
    super.key,
    this.icon     = Iconsax.activity,
    this.title    = 'titulo',
    this.data     = '0.0',
    this.width    = 540,
    this.lastWeek = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height    : 90,
      width     : width,
      margin    : const EdgeInsets.only(bottom: 5),
      padding   : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color       : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow   : const [
          BoxShadow(
            color       : Color.fromARGB(10, 0, 0, 0),
            blurRadius  : 5,
            spreadRadius: 2,
            offset      : Offset(0, 2),
          )
        ]
      ),
      child     : InkWell(
        onTap   : onTap,
        child   : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children          : [
            iconC(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                dividers(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data, style: Get.textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(width: 20),
                  ]
                )
              ]
            )
          ]
        )
      )
    );
  }

  iconC(context){
    return Container(
      width     : 55,
      height    : 55,
      margin    : const EdgeInsets.only(top: 3, right: 12 ),
      decoration: BoxDecoration( 
        color       : Theme.of(context).primaryColor.withOpacity(.5),
        borderRadius: const  BorderRadius.all(Radius.circular(15)),
      ),
      child     : Icon(icon, color: Colors.white),
    );
  }

  dividers(){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Stack(
        children: [
          Container(
            height: 2,
            width : 70,
            margin: const EdgeInsets.only(top: 1),
            color : Colors.grey.withOpacity(.2),
          ),
          Container(
            height: 4,
            width : 40,
            color : Get.theme.primaryColorLight.withOpacity(.3),
          )
        ]
      )
    );
  }

  badget(){
    return Container(
      height    : 20,
      width     : 40,
      decoration: BoxDecoration( 
        color       : Get.theme.primaryColor.withOpacity(.5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: const Center(child: Text('+ 20', style: TextStyle(fontSize: 11, color: Colors.black54))),
    );
  }
}