import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/card/v1/card/main_multi_title_card.dart';
import '../controllers/home_controller.dart';

class HomeTablet extends GetView<HomeController> {
  const HomeTablet({super.key});
 
  content(context){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15,  vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estadisticas diarias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 10),
          dailyData(context),
        ]
      )
    );
  }

  dailyData(context){
    
    double width      = MediaQuery.of(context).size.width / 2.14;
    return Obx(() =>  Wrap(
      spacing     : 20,
      runSpacing  : 20,
      children    : [
        for (var i = 0; i < 10; i++)
          MultiTitleCard(
            width     : width,
            height    : width,
            title     : 'Ingresos',
            subtitle  : 'Total de ingresos',
            content   : Text('${controller.brain.contentWidth.value} ${MediaQuery.of(context).size.width}'),
          )
      ]
    ));
  }

  @override
  Widget build(BuildContext context) {
    return  content(context);  
  }
}