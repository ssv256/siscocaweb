import 'package:domain/models/task/index.dart';
import 'package:siscoca/app/data/services/task/task.dart';

class TaskRepository {

  final TaskService _service;

  TaskRepository(this._service);

  Future<List<Task>> getTasks() => _service.getTasks();

  // Create a new task
  Future<Task> createTask(Task task) => _service.createTask(task);

  // Update an existing task
  Future<Task> updateTask(Task task) => _service.updateTask(task);

  // Delete a task
  Future<void> deleteTask(int id) => _service.deleteTask(id);

  //Desactivate task
  Future<void> desactivateTask(int id) => _service.desactivateTask(id);

  // Get a specific task by ID
  Future<Task> getTaskById(int id) => _service.getTaskById(id);
}