
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../widgets/buttons/ed_button.dart';
import '../controllers/home_controller.dart';

class SubscriptionCard extends GetView<HomeController> {
  const SubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin    :const EdgeInsets.only(bottom: 5),
      padding   : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration:  BoxDecoration( 
        color       : Get.theme.primaryColor,
        borderRadius:  const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Text('Detalles de subscripción'),
              Icon(Iconsax.notification, color:Colors.red,)
            ]
          ),
          const Divider(color: Colors.grey),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Text('Duración'),
                        Text('30 Días'),
                      ]
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Text('Costo:'),
                        Text('200000'),
                      ]
                    ),
                     Text(style: TextStyle(fontSize: 10),'Tu subscripcion se encuentra en proceso de pago, completalo para poder disfrutar de todos los beneficios')
                  ]
                ),
              ),
              Container(margin: const EdgeInsets.symmetric(horizontal: 10), color: Colors.grey,height: 100, width: 1, child: const VerticalDivider()),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          const Text('PreFactura'),
                          Text('Ver', style: TextStyle(color: Colors.yellow[900]),),
                      ]
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child :  EdButton(
                        width       : double.infinity,
                        height      : 50,
                        borderRadius: 10,
                        textColor   : Colors.white,
                        bgColor     : Colors.white10,
                        text        : 'Enviar Orden de cobro',
                        onTap       : (){}
                      )
                    )
                  ]
                ),
              )
            ]
          )
        ]
      )
    );
  }
}