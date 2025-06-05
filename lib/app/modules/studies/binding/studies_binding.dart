import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/study/study_repository.dart';
import 'package:siscoca/app/data/services/study/study_service.dart';
import 'package:siscoca/app/modules/studies/index.dart';

class StudyBinding implements Bindings {
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
    Get.lazyPut<StudyController>(
      () => StudyController(repository: Get.find()),
    );
  }
}