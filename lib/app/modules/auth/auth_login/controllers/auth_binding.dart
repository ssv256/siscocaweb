import 'package:get/get.dart';
import 'package:siscoca/app/modules/auth/auth_login/auth_view.dart';
import 'auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(tokenStorage: Get.find()));
    Get.put(AuthViewHelper()); 
  }
}