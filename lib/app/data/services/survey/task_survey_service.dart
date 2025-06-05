import 'package:api/api.dart';
import 'package:domain/domain.dart';

class TaskSurveyService {
  /// Get all survey tasks
  Future<List<Task>> getTasks() async {
    try {
      final (data, error) = await CococareTaskApi.getTasks();
      if (error.isNotEmpty) {
        throw TaskSurveyException('Failed to fetch survey tasks: $error');
      }
      final tasks = data?.map((json) => Task.fromJson(json)).toList() ?? [];
      // Filter only survey type tasks
      return tasks.where((task) => task.taskType!.name == 'survey').toList();
    } catch (e) {
      throw TaskSurveyException('Error fetching survey tasks: $e');
    }
  }

  /// Get assigned survey tasks for a specific patient
  Future<List<Task>> getAssignedTaskSurvey(String id) async {
    try {
      final (data, error) = await CococareTaskApi.getAssignedTasks(id);
      if (error.isNotEmpty) {
        throw TaskSurveyException('Failed to fetch assigned survey tasks: $error');
      }
      final tasks = data?.map((json) => Task.fromJson(json)).toList() ?? [];
      // Filter only survey type tasks
      return tasks.where((task) => task.taskType!.name == 'survey').toList();
    } catch (e) {
      throw TaskSurveyException('Error fetching assigned survey tasks: $e');
    }
  }

  /// Get a specific task by ID
  Future<Task> getTaskById(int id) async {
    try {
      final (data, error) = await CococareTaskApi.getTaskById(id);
      if (error.isNotEmpty) {
        throw TaskSurveyException('Failed to fetch survey task: $error');
      }
      if (data == null) {
        throw TaskSurveyException('Survey task not found');
      }
      
      final task = Task.fromJson(data);
      if (task.taskType!.name != 'survey') {
        throw TaskSurveyException('Task is not a survey type');
      }
      
      return task;
    } catch (e) {
      throw TaskSurveyException('Error fetching survey task: $e');
    }
  }

  /// Get assigned survey tasks for a specific patient
  Future<List<TaskResponse>> getTasksResponseSurveyPatient(String id) async {
    try {
      final (data, error) = await CococareTaskResponseApi.getTaskSurveyResponseByPatient(id);
      if (error.isNotEmpty) {
        throw TaskSurveyException('Failed to fetch assigned survey tasks: $error');
      }
      final tasks = data?.map((json) => TaskResponse.fromJson(json)).toList() ?? [];
      return tasks;
    } catch (e) {
      throw TaskSurveyException('Error fetching assigned survey tasks: $e');
    }
  }
}

/// Custom exception class for task-related errors
class TaskSurveyException implements Exception {
  final String message;
  TaskSurveyException(this.message);

  @override
  String toString() => 'TaskException: $message';
}