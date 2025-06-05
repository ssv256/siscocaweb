import 'package:api/api.dart';
import 'package:domain/domain.dart';

class TaskService {
  
  Future<List<Task>> getTasks() async {
    try {
      final (data, error) = await CococareTaskApi.getTasks();
      if (error.isNotEmpty) {
        throw TaskException('Failed to fetch tasks: $error');
      }
      return data?.map((json) => Task.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw TaskException('Error fetching tasks: $e');
    }
  }

  /// Get task by id task
  Future<Task> getTaskById(int id) async {
    try {
      final (data, error) = await CococareTaskApi.getTaskById(id);
      if (error.isNotEmpty) {
        throw TaskException('Failed to fetch tasks: $error');
      }
      return Task.fromJson(data!);
    } catch (e) {
      throw TaskException('Error fetching tasks: $e');
    }
  }

  /// Get task assigned to the patient
  Future<List<Task>> getAssignedTasks(String id) async {
    try {
      final (data, error) = await CococareTaskApi.getAssignedTasks(id);
      if (error.isNotEmpty) {
        throw TaskException('Failed to fetch tasks: $error');
      }
      return data?.map((json) => Task.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw TaskException('Error fetching tasks: $e');
    }
  }

  /// Creates a new task
  Future<Task> createTask(Task task) async {
    try {
      final (data, error) = await CococareTaskApi.postTask(task.toJson());
      if (error.isNotEmpty) {
        throw TaskException('Failed to create task: $error');
      }
      return Task.fromJson(data!);
    } catch (e) {
      throw TaskException('Error creating task: $e');
    }
  }

  /// Updates an existing task
  Future<Task> updateTask(Task task) async {
    try {
      final (data, error) = await CococareTaskApi.putTask(task.toJson());
      if (error.isNotEmpty) {
        throw TaskException('Failed to update task: $error');
      }
      return Task.fromJson(data!);
    } catch (e) {
      throw TaskException('Error updating task: $e');
    }
  }

  /// Deletes a task by ID
  Future<bool> deleteTask(int id) async {
    try {
      final (data, error)= await CococareTaskApi.deleteTask(id);
      if (error.isNotEmpty) {
        throw TaskException('Failed to delete task: $error');
      }
      return true;
    } catch (e) {
      throw TaskException('Error deleting task: $e');
    }
  }

  /// Deletes a task by ID
  Future<bool> desactivateTask(int id) async {
    try {
      final (data, error)= await CococareTaskApi.desactivateTask(id);
      if (error.isNotEmpty) {
        throw TaskException('Failed to delete task: $error');
      }
      return true;
    } catch (e) {
      throw TaskException('Error deleting task: $e');
    }
  }
}

/// Custom exception class for task-related errors
class TaskException implements Exception {
  final String message;
  TaskException(this.message);

  @override
  String toString() => 'TaskException: $message';
}