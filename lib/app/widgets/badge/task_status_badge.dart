import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BadgeMode extends StatelessWidget {
  final bool close;
  final int status;
  final bool supervisor;

  const BadgeMode({ 
    super.key,
    this.status = 1,
    this.close = false,
    this.supervisor = false
  });

  Color selectColors(){
    if(supervisor){
      switch (status) {
        case 0:
          return Colors.amber;
        case 1:
          return const Color.fromARGB(255, 34, 145, 38); 
        case 2:
          return Get.theme.primaryColor;
        case 3:
        return const Color.fromARGB(255, 85, 217, 89); 
        case 4:
          return  const Color.fromRGBO(152, 14, 52, 0.8);
        case 5:
          return const Color.fromARGB(255, 216, 109, 32);
        default:
        return  const Color.fromRGBO(152, 14, 52, 0.8);
      }
    }else{
      switch (status) {
        case 0:
          return Colors.amber;
        case 1:
          return Get.theme.primaryColorLight;
        case 2:
          return Get.theme.primaryColor;
        case 3:
        return const Color.fromARGB(255, 85, 217, 89); 
        case 4:
          return  const Color.fromRGBO(152, 14, 52, 0.8);
        case 5:
          return const Color.fromARGB(255, 216, 109, 32);
        default:
        return  const Color.fromRGBO(152, 14, 52, 0.8);
      }
    }
    
  }

  title(){
    if(supervisor){
      switch (status) {
        case 0:
          return 'Por asignar';
        case 1:
          return 'Asignada';
        case 2:
          return 'Por revisar';
        case 3:
          return 'Completada';
        case 4:
          return 'Cancelada';
        case 5:
          return 'Sin completar';
        default:
          return 'Por asignar';
      }
    }else{
      switch (status) {
        case 1:
          return 'Por Iniciar';
        case 2:
          return 'Gestionada';
        case 3:
          return 'Completada';
        case 4:
          return 'Cancelada';
        case 5:
          return 'Sin completar';
        default:
          return 'Sin asignar';
      }
    }

  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height    : 30,
      width     : 110,
      padding   : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color:  selectColors(), borderRadius: BorderRadius.circular(10)),
      child     :  Center(
        child: Text(title(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)
      ),
    );
  }
}