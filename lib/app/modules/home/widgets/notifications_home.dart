import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/card/v1/card/main_card.dart';
import '../../../widgets/card/v1/card/alert_card.dart';

class AlertsHome extends StatelessWidget {
 final List<Alert> alerts;

 const AlertsHome({
   super.key, 
   required this.alerts,
 });

 @override
 Widget build(BuildContext context) {
   return Obx(() {
     final screenWidth = MediaQuery.of(context).size.width;
     final screenHeight = MediaQuery.of(context).size.height;

     return MainCard(
       margin: EdgeInsets.zero,
       width: screenWidth * 0.29,
       height: screenHeight * 0.57,
       child: Column(
         children: [
           Row(
             children: [
               const Text(
                 'Alertas',
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 20,
                   fontWeight: FontWeight.w500
                 ),
               ),
               const Spacer(),
               Container(
                 width: 30,
                 height: 30,
                 decoration: BoxDecoration(
                   color: Colors.red,
                   borderRadius: BorderRadius.circular(7),
                 ),
                 child: Center(
                   child: Text(
                     alerts.length.toString(),
                     style: const TextStyle(
                       color: Colors.white,
                       fontSize: 16,
                     ),
                   ),
                 ),
               ),
             ],
           ),
           const Divider(color: Colors.black12),
           const SizedBox(height: 10),
           if (alerts.isEmpty)
             const Expanded(
               child: Center(
                 child: Text('No hay notificaciones')
               )
             )
           else  
             Expanded(
               child: ListView.builder(
                 itemCount: alerts.length,
                 itemBuilder: (context, index) {
                   return AlertCard(
                     alert: alerts[index],
                     width: screenWidth * 0.23,
                   );
                 },
               ),
             ),
         ],
       ),
     );
   });
 }
}