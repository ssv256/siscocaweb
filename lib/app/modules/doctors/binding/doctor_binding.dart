import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/doctor/doctor_repository.dart';
import 'package:siscoca/app/data/services/doctor/doctor_service.dart';
import 'package:siscoca/app/modules/doctors/index.dart';

class DoctorBinding implements Bindings {
  @override
  void dependencies() {
    // Register service
    Get.lazyPut<DoctorService>(
      () => DoctorService(),
    );

    // Register repository
    Get.lazyPut<DoctorRepository>(
      () => DoctorRepository(Get.find<DoctorService>()),
    );

    // Register controller
    Get.lazyPut<DoctorController>(
      () => DoctorController(repository: Get.find()),
    );

    // Register create/edit controller
    Get.lazyPut<DoctorCreateController>(
      () => DoctorCreateController(repository: Get.find()),
    );
  }
}
