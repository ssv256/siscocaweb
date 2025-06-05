import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_impl_repository.dart';
import 'package:siscoca/app/data/repository/patient/measures.dart';
import 'package:siscoca/app/data/repository/patient/patient.dart';
import 'package:siscoca/app/data/services/alerts/alerts_service.dart';
import 'package:siscoca/app/data/services/patients/measures.dart';
import 'package:siscoca/app/data/services/patients/patients.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<PatientService>(
      PatientService(),
    );

    Get.put<MeasureService>(
      MeasureService(),
    );

    Get.put<AlertService>(
      AlertService(),
    );

    // Repositories
    Get.put<PatientRepository>(
      PatientRepository( Get.find<PatientService>()),
    );

    Get.put<MeasureRepository>(
      MeasureRepository( Get.find<MeasureService>()),
    );

    Get.put<AlertRepositoryImpl>(
      AlertRepositoryImpl( Get.find<AlertService>()),
    );

    Get.put<HomeController>(
      HomeController(
        patientRepository: Get.find<PatientRepository>(),
        measureRepository: Get.find<MeasureRepository>(),
        alertRepository: Get.find<AlertRepositoryImpl>(),
      ),
    );

    // Controller
    // Get.put<PatientsCreateController>(
    //   PatientsCreateController(
    //     Get.find<PatientRepository>()
    //   ),
    // );
  }
}