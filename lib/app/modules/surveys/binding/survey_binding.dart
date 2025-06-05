import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/survey/survey_repository.dart';
import 'package:siscoca/app/data/repository/task/task_repository.dart';
import 'package:siscoca/app/data/services/survey/task_survey_service.dart';
import 'package:siscoca/app/data/services/task/task.dart';
import 'package:siscoca/app/modules/surveys/index.dart';
import 'package:siscoca/app/modules/surveys/surveys_response/controller/survey_response_controller.dart';

class SurveyBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<TaskSurveyService>(() => TaskSurveyService());
    Get.lazyPut<TaskService>(() => TaskService());
    // Repository
    Get.lazyPut(() => TaskRepository(Get.find<TaskService>()));
    Get.lazyPut(() => TaskSurveyRepository(Get.find<TaskSurveyService>()));

    // Controllers
    Get.lazyPut(() => SurveyController(
      taskRepository: Get.find<TaskRepository>(),
      taskSurveyRepository: Get.find<TaskSurveyRepository>(),
    ));

    Get.lazyPut(() => SurveysCreateController(
      taskRepository: Get.find<TaskRepository>()
    ));

    Get.lazyPut(() => SurveyResponseController(
      taskSurveyRepository: Get.find<TaskSurveyRepository>(),
    ));
  }
}