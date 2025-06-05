import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/card/v1/card/main_multi_title_card.dart';
import '../controllers/home_controller.dart';

class HomeMobile extends GetView<HomeController>  {
  const HomeMobile({super.key});

  content(context){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15,  vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estadisticas diarias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 10),
          for (var i = 0; i < 10; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child : MultiTitleCard(
                width     : double.infinity,
                height    : MediaQuery.of(context).size.width / 1.3,
                title     : 'Ingresos',
                subtitle  : 'Total de ingresos',
                content   : Text('${controller.brain.contentWidth.value} ${MediaQuery.of(context).size.width}'),
              ),
            )
        ]
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return  content(context);  
  }
}