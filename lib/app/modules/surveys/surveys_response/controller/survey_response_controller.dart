import 'package:domain/models/models.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/survey/survey_repository.dart';

class SurveyResponseController extends GetxController {
  final TaskSurveyRepository taskSurveyRepository;
  final Brain brain = Get.find<Brain>();
  
  // Using RxList for reactive list of TaskResponse
  final RxList<TaskResponse> surveysResponse = <TaskResponse>[].obs;
  final RxBool isLoading = false.obs;
  
  SurveyResponseController({
    required this.taskSurveyRepository,
  });

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is User) {
      final User patient = Get.arguments as User;
      if (patient.id != null) {
        _loadSurveysResponseList(patient);
      }
    } else {
      Get.snackbar(
        'Error',
        'Invalid patient data',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _loadSurveysResponseList(User patient) async {
    try {
      isLoading.value = true;
      final responses = await taskSurveyRepository.getTasksResponseSurveyPatient(
        patient.id!,
      );
      surveysResponse.assignAll(responses);
      
    } catch (e) {
      if (e.toString().contains('404')) {
        surveysResponse.clear();
      } else {
        Get.snackbar(
          'Error',
          'Failed to load surveys: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
        surveysResponse.clear();
      }
    } finally {
      isLoading.value = false;
    }
  } 
}