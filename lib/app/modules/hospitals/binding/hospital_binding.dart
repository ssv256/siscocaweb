import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/hospital/hospital_repository.dart';
import 'package:siscoca/app/data/services/hospital/hospital_service.dart';
import 'package:siscoca/app/modules/hospitals/hospitals_create/controllers/hospitals_create_controller.dart';
import 'package:siscoca/app/modules/hospitals/hospitals_view/controllers/hospitals_controller.dart';

class HospitalBinding implements Bindings {
  @override
  void dependencies() {
    // Register service
    Get.lazyPut<HospitalService>(
      () => HospitalService(),
    );

    // Register repository
    Get.lazyPut<HospitalRepository>(
      () => HospitalRepository(Get.find<HospitalService>()),
    );

    // Register controller
    Get.lazyPut<HospitalController>(
      () => HospitalController(repository: Get.find()),
    );

    // Register create/edit controller
    Get.lazyPut<HospitalCreateController>(
      () => HospitalCreateController(repository: Get.find()),
    );
  }
}