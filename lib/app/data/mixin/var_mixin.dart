
import 'package:get/get.dart';

mixin VarMixin {

  final Map<String?, Rx<dynamic>> variables = {};

  /// Recibe el nombre de una variable [key] para ubicarlo en el map
  /// si este no existe regresara un valor correspondiente al [Type];
   Rx<dynamic> varGet(String varId,  Type t) {
    if (!variables.containsKey(varId)) {
      if(t == String){
        variables[varId] = RxString('');
      }else if(t == num){ 
        variables[varId] =  RxInt(0);
      }else if(t == List){ 
        variables[varId] =  Rx<dynamic>([]);
      }else if(t == bool){ 
        variables[varId] =   RxBool(false);
      }else{
        variables[varId] = Rx<dynamic>(null);
      }
    }
    return variables[varId]!;
  }

  ///Remueve la variable segun su [key]
  void varRemove(String varId) {
    if (variables.containsKey(varId)) {
      variables.remove(varId);
    }
  }

  varSet(String varId, dynamic value, ) {
    if (!variables.containsKey(varId)) {
      //Guardamos la variable con su type
      variables[varId] =  Rx<dynamic>(value);
    } else {
      variables[varId]!.value = value;
    }
  }

  ///Limpia todos los loader registrados
  void varClear() {
    variables.clear();
  }
}