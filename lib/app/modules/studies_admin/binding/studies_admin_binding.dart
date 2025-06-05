import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/study/study_repository.dart';
import 'package:siscoca/app/data/services/study/study_service.dart';
import 'package:siscoca/app/modules/studies_admin/index.dart';

class StudyAdminBinding implements Bindings {
  @override
  void dependencies() {
    // Register service
    Get.lazyPut<StudyService>(
      () => StudyService(),
    );

    // Register repository
    Get.lazyPut<StudyRepository>(
      () => StudyRepository(Get.find<StudyService>()),
    );

    // Register controller
    Get.lazyPut<StudyAdminController>(
      () => StudyAdminController(repository: Get.find()),
    );

    // Register create/edit controller
    Get.lazyPut<StudyAdminCreateController>(
      () => StudyAdminCreateController(repository: Get.find()),
    );
  }
}