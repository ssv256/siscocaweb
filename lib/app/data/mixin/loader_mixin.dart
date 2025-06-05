import 'package:get/get.dart';

/// Controla todos los [loader] que se generan por alguna acción
/// o petición de un [usuario].
mixin LoaderMixin {

  final Map<String?, RxBool> loaders = {};

  /// Recibe el nombre de un loader [key] para ubicarlo en el map
  /// si este no existe regresara false;
  RxBool loader(String loaderId) {
    if (!loaders.containsKey(loaderId)) {
      loaders[loaderId] = RxBool(false);
    }
    return loaders[loaderId]!;
  }
  
  ///Remueve el loader segun su [key]
  void loaderRemove(String loaderId) {
    if (loaders.containsKey(loaderId)) {
      loaders.remove(loaderId);
    }
  }

  loaderSet(String loaderId, bool value) {
    if (!loaders.containsKey(loaderId)) {
      loaders[loaderId] = RxBool(value);
    } else {
      loaders[loaderId]!.value = value;
    }
  }

  ///Limpia todos los loader registrados
  void loaderClear() {
    loaders.clear();
  }

}
