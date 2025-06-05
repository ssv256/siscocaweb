import 'package:domain/models/task/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/survey/survey_repository.dart';
import 'package:siscoca/app/data/repository/task/task_repository.dart';

class SurveyController extends GetxController {
  final TaskSurveyRepository taskSurveyRepository;
  final TaskRepository taskRepository;

  SurveyController({
    required this.taskSurveyRepository,
    required this.taskRepository,
  });

  final searchController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final width = 1000.0.obs;
  final surveys = <Task>[].obs;
  final surveysFiltered = <Task>[].obs;
  final selectedStatus = 'Todos'.obs;
  final Brain brain = Get.find<Brain>();
  
  // Date filter observables
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final isDateFilterActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSurveys();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Handler for search field changes
  void _onSearchChanged() {
    filter(searchController.text);
  }

  /// Load all surveys
  Future<void> _loadSurveys() async {
    isLoading.value = true;
    try {
      final result = await taskSurveyRepository.getTasksSurvey();
      surveys.assignAll(result);
      surveysFiltered.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load surveys: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Public method to refresh surveys
  Future<void> refreshSurveys() async {
    await _loadSurveys();
  }

  /// Filter surveys by text, status, and date range
  void filter(String value) {
    // Start with all surveys
    List<Task> filtered = surveys;

    // Apply status filter
    if (selectedStatus.value != 'Todos') {
      final statusValue = selectedStatus.value == 'Activo' ? 1 : 0;
      filtered = filtered.where((survey) => 
        survey.status == statusValue
      ).toList();
    }

    // Apply date filter if active
    if (isDateFilterActive.value && startDate.value != null) {
      final start = startDate.value!;
      final end = endDate.value ?? DateTime.now();
      
      filtered = filtered.where((survey) {
        if (survey.createdAt == null) return false;
        
        try {
          final createdDate = DateTime.parse(survey.createdAt!);
          // Set time to 00:00:00 for start date and 23:59:59 for end date for inclusive comparison
          final startWithoutTime = DateTime(start.year, start.month, start.day);
          final endWithoutTime = DateTime(end.year, end.month, end.day, 23, 59, 59);
          
          return createdDate.isAfter(startWithoutTime.subtract(const Duration(seconds: 1))) && 
                 createdDate.isBefore(endWithoutTime.add(const Duration(seconds: 1)));
        } catch (e) {
          return false;
        }
      }).toList();
    }

    // Apply text filter
    if (value.trim().isNotEmpty) {
      final searchValue = value.toLowerCase().trim();
      filtered = filtered.where((survey) {
        return survey.name.toLowerCase().contains(searchValue) ||
               survey.description.toLowerCase().contains(searchValue) ||
               survey.advertisement!.toLowerCase().contains(searchValue);
      }).toList();
    }

    surveysFiltered.assignAll(filtered);
  }

  /// Filter surveys by status
  void filterByStatus() {
    filter(searchController.text);
  }

  /// Filter surveys by date range
  void filterByDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    
    if (start == null) {
      isDateFilterActive.value = false;
    } else {
      isDateFilterActive.value = true;
    }
    
    filter(searchController.text);
  }

  /// Clear date filter
  void clearDateFilter() {
    startDate.value = null;
    endDate.value = null;
    isDateFilterActive.value = false;
    filter(searchController.text);
  }

  /// Removes a survey by ID
  Future<void> removeData(int id) async {
    isLoading.value = true;
    try {
      taskRepository.deleteTask(id);
      Get.snackbar(
        'Success',
        'Survey deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete survey: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> desactivateTask(int id) async {
    isLoading.value = true;
    try {
      taskRepository.deleteTask(id);
      Get.snackbar(
        'Success',
        'Survey deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete survey: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get surveys for a specific patient
  Future<void> loadPatientSurveys(String patientId) async {
    isLoading.value = true;
    try {
      final result = await taskSurveyRepository.getAssignedTaskSurvey(patientId);
      surveys.assignAll(result);
      surveysFiltered.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load patient surveys: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper method to format date
  String formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  /// Helper method to get status text
  String getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Activo';
      case 0:
        return 'Inactivo';
      default:
        return 'Desconocido';
    }
  }

  /// Helper method to get task type name
  String getTaskTypeName(TaskType taskType) {
    return taskType.name.capitalizeFirst ?? 'Unknown';
  }

  int getQuestionCount(Task survey) {
    if (survey.details is SurveyTaskDetails) {
      return (survey.details as SurveyTaskDetails)
        .questions['steps']?.length ?? 0;
    }
    return 0;
  }
}