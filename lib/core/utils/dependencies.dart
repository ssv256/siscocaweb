
import 'package:api/token/token_storage.dart';
import 'package:get/get.dart';
import '../../app/data/controller/brain.dart';
import '../../app/modules/main/controller/main_controller.dart';


class DependencyInjection {
  static void init() { 
    Get.put<Brain>(Brain());
    Get.put<TokenStorage>(InMemoryTokenStorage(), permanent: true);
    Get.put<MainController>(MainController());
  }
}