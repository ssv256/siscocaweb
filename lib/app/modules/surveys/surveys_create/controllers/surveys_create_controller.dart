import 'package:domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:research_package/research_package.dart';
import 'package:siscoca/app/data/mixin/var_mixin.dart';
import 'package:siscoca/app/data/repository/task/task_repository.dart';
import 'package:siscoca/app/modules/surveys/surveys_create/controllers/ext_survey_create_controller.dart';
import 'package:siscoca/app/modules/surveys/surveys_view/controllers/survey_controller.dart';
import 'package:toastification/toastification.dart';
import '../../../../data/controller/brain.dart';
import '../../../../data/mixin/text_field_mixin.dart';
import 'src/survey_manager.dart';

class SurveysCreateController extends GetxController with TextFieldMixin, VarMixin {

  final TaskRepository taskRepository;
  final Rx<Task?> currentTask = Rx<Task?>(null);
  final RxString previousTaskId = ''.obs;

  SurveysCreateController({
    required this.taskRepository,
  });

  final Brain brain = Get.find<Brain>();
  final formKey = GlobalKey<FormState>();
  final RxDouble cardWidth = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> questions = <dynamic>[].obs;
  final width = 0.0.obs;
  final SurveyManager surveyManager = SurveyManager();

  // Reactive variables para el questionModal
  final RxString questionType = 'Radio'.obs;
  final RxBool isMultipleChoice = false.obs;
  final RxList<Map<String, dynamic>> questionOptions = <Map<String, dynamic>>[].obs;
  final Rx<RPStep?> stepToEdit = Rx<RPStep?>(null);
  final RxString dateTimeType = 'TimeOfDay'.obs;
  final RxList<Map<String, dynamic>> imageOptions = <Map<String, dynamic>>[].obs;
  final RxInt status = 1.obs;

  // Survey task
  final Rx<RPOrderedTask> surveySelected = Rx<RPOrderedTask>(
    RPOrderedTask(identifier: "initial", steps: [])
  );

  @override
  void onInit() {
    super.onInit();
    width.value = Get.width - 30;
    
    // Listen to questionType changes
    ever(questionType, (type) {
      if (type == 'Radio') {
        if (questionOptions.isEmpty) {
          addDefaultOptions();
        }
      }
    });
  }
  
  @override
  void onReady() {
    super.onReady();
    _initializeFromArguments();
  }
  
  @override
  void onClose() {
    _resetState();
    super.onClose();
  }
  
  // This method will be called when the view is opened
  void onViewOpen() {
    final task = Get.arguments?['task'] as Task?;
    final String currentId = task?.id?.toString() ?? '';
    
    // Only reinitialize if the task has changed
    if (currentId != previousTaskId.value) {
      _resetState();
      
      if (task != null) {
        _initializeEditMode(task);
      } else {
        _initializeCreateMode();
      }
      
      // Update the previous task ID
      previousTaskId.value = currentId;
    }
  }
  
  void _initializeFromArguments() {
    _resetState();
    
    final task = Get.arguments?['task'] as Task?;
    if (task != null) {
      _initializeEditMode(task);
      previousTaskId.value = task.id?.toString() ?? '';
    } else {
      _initializeCreateMode();
      previousTaskId.value = '';
    }
  }
  
  void _resetState() {
    // Clear all state
    currentTask.value = null;
    textFieldController('title').text = '';
    textFieldController('description').text = '';
    textFieldController('advertencia').text = '';
    status.value = 1;
    questionOptions.clear();
    stepToEdit.value = null;
    surveySelected.value = RPOrderedTask(identifier: "initial", steps: []);
  }

  void _initializeEditMode(Task task) {
    currentTask.value = task;
    textFieldController('title').text = task.name;
    textFieldController('description').text = task.description;
    textFieldController('advertencia').text = task.advertisement ?? '';
    status.value = task.status ?? 1;
    
    // Cargar la encuesta existente
    if (task.details is SurveyTaskDetails) {
      final surveyDetails = task.details as SurveyTaskDetails;
      //need call this fuction to uss fromJson factory in RPOrderedTas
      registerFromJsonFunctions();
      surveySelected.value = RPOrderedTask.fromJson(surveyDetails.questions);
    }
  }

  void _initializeCreateMode() {
    surveyManager.initializeTask(
      identifier: "survey_${DateTime.now().millisecondsSinceEpoch}",
      title: "Nueva Encuesta",
    );
    if (questionType.value == 'Radio') {
      addDefaultOptions();
    }
  }

  void updateStatus(int newStatus) {
    status.value = newStatus;
  }
  
  void _showSuccessToast(String message) {
    toastification.show(
      closeOnClick: true,
      icon: const Icon(Iconsax.check),
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
      style: ToastificationStyle.flat,
    );
  }

  void _showErrorToast(String message) {
    toastification.show(
      closeOnClick: true,
      icon: const Icon(Iconsax.warning_2),
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
      style: ToastificationStyle.flat,
    );
  }

  Future<void> createOrUpdateSurvey() async {
    try {
      isLoading.value = true;
      ensureInstructionStep();
      ensureCompletionStep();
      final surveyDetails = SurveyTaskDetails(
        questions: surveySelected.value.toJson()
      );

      final taskType = TaskType(id: 1, name: 'survey');
      final taskData = Task(
        id: currentTask.value?.id,
        name: textFieldController('title').text,
        description: textFieldController('description').text,
        advertisement: textFieldController('advertencia').text,
        taskTypeId: taskType.id,
        status: status.value,
        details: surveyDetails,
      );

      if (currentTask.value != null) {
        await taskRepository.updateTask(taskData);
        _showSuccessToast('Survey updated successfully');
      } else {
        await taskRepository.createTask(taskData);
        _showSuccessToast('Survey created successfully');
      }
      
      // Refresh the survey list in the main view
      if (Get.isRegistered<SurveyController>()) {
        final surveyController = Get.find<SurveyController>();
        await surveyController.refreshSurveys();
      }
      
      // Navigate back to the survey list
      Get.back();
    } catch (e) {
      _showErrorToast('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}