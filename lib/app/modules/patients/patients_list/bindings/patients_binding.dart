import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_impl_repository.dart';
import 'package:siscoca/app/data/repository/patient/patient.dart';
import 'package:siscoca/app/data/repository/study/study_repository.dart';
import 'package:siscoca/app/data/services/alerts/alerts_service.dart';
import 'package:siscoca/app/data/services/patients/patients.dart';
import 'package:siscoca/app/data/services/study/study_service.dart';
import 'package:siscoca/app/modules/patients/patients_list/controllers/patients_list_controller.dart';

class PatientListBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<PatientService>(() => PatientService(),
      fenix: true,
    );

    // Register the Study Service
    Get.lazyPut<StudyService>(() => StudyService(),
      fenix: true,
    );
    
    // Register the Alert Service
    Get.lazyPut<AlertService>(() => AlertService(),
      fenix: true,
    );

    // Register the Patient Repository with its service dependency
    Get.lazyPut<PatientRepository>(
      () => PatientRepository(Get.find<PatientService>()),
      fenix: true,
    );

    // Register the Study Repository with its service dependency
    Get.lazyPut<StudyRepository>(
      () => StudyRepository(Get.find<StudyService>()),
      fenix: true,
    );
    
    // Register the Alert Repository with its service dependency
    Get.lazyPut<AlertRepositoryImpl>(
      () => AlertRepositoryImpl(Get.find<AlertService>()),
      fenix: true,
    );

    // Register the Patient Controller with its repository dependency
    Get.lazyPut<PatientListController>(
      () => PatientListController(
        repository: Get.find(),
        studyRepository: Get.find(),
        alertRepository: Get.find(),
      ),
      fenix: true,
    );
  }
}