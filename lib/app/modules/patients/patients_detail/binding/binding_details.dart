import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_impl_repository.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_threshold_impl_rep.dart';
import 'package:siscoca/app/data/repository/medical_passport/medical_passport_repository.dart';
import 'package:siscoca/app/data/repository/patient/measures.dart';
import 'package:siscoca/app/data/repository/patient/patient.dart';
import 'package:siscoca/app/data/repository/study/study_repository.dart';
import 'package:siscoca/app/data/services/alerts/alerts_service.dart';
import 'package:siscoca/app/data/services/alerts/alerts_threshold_service.dart';
import 'package:siscoca/app/data/services/medical_passport/medical_passport_service.dart';
import 'package:siscoca/app/data/services/patients/measures.dart';
import 'package:siscoca/app/data/services/patients/patients.dart';
import 'package:siscoca/app/data/services/study/study_service.dart';
import 'package:siscoca/app/modules/patients/patients_detail/controllers/patients_detail_controller.dart';

class PatientDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<PatientService>(
      PatientService(),
      permanent: true,
    );
    Get.lazyPut<StudyService>(
      () => StudyService(),
    );
    Get.lazyPut<MeasureService>(
      () => MeasureService(),
    );
    Get.put<MedicalPassportService>(
      MedicalPassportService(),
      permanent: true,
    );
    // Add AlertService
    Get.lazyPut<AlertService>(
      () => AlertService(),
    );
    // Add AlertThresholdService
    Get.lazyPut<AlertThresholdService>(
      () => AlertThresholdService(),
    );

    // Repositories
    Get.put<PatientRepository>(
      PatientRepository(Get.find<PatientService>()),
    );
    Get.lazyPut<StudyRepository>(
      () => StudyRepository(Get.find<StudyService>()),
    );
    Get.put<MedicalPassportRepositoryWeb>(
      MedicalPassportRepositoryWeb(
        Get.find<MedicalPassportService>(),
      ),
    );
    Get.put<MeasureRepository>(
      MeasureRepository(Get.find<MeasureService>()),
    );
    // Add AlertRepositoryImpl
    Get.lazyPut<AlertRepositoryImpl>(
      () => AlertRepositoryImpl(Get.find<AlertService>()),
    );
    // Add AlertThresholdRepositoryImpl
    Get.lazyPut<AlertThresholdRepositoryImpl>(
      () => AlertThresholdRepositoryImpl(Get.find<AlertThresholdService>()),
    );

    // Controller - Make sure it's recreated each time
    // Remove any existing controller first to ensure clean state
    if (Get.isRegistered<PatientsDetailController>()) {
      Get.delete<PatientsDetailController>();
    }
    
    // Register the controller without making it permanent
    Get.put<PatientsDetailController>(
      PatientsDetailController(
        Get.find<PatientRepository>(),
        Get.find<MedicalPassportRepositoryWeb>(),
        Get.find<MeasureRepository>(),
      ),
    );
  }
}