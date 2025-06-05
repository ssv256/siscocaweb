import 'package:domain/models/task/index.dart';
import 'package:siscoca/app/data/services/survey/task_survey_service.dart';

class TaskSurveyRepository {

  final TaskSurveyService _service;

  TaskSurveyRepository(this._service);

  Future<List<Task>> getTasksSurvey() => _service.getTasks();

  // Get Assigned task_survey to a patient
  Future<List<Task>> getAssignedTaskSurvey(String id) => _service.getAssignedTaskSurvey(id);

  // Get a specific task by ID
  Future<Task> getTaskSurveyById(int id) => _service.getTaskById(id);

  // Get all taskResponseSurvey from a patient
  Future<List<TaskResponse>> getTasksResponseSurveyPatient(String id) => _service.getTasksResponseSurveyPatient(id);


  // // Create a new task
  // Future<Task> createTaskSurvey(Task task) => _service.createTask(task);

  // // Update an existing task
  // Future<Task> updateTaskSurvey(int id, Task task) => _service.updateTask(id, task);

  // // Delete a task
  // Future<void> deleteTaskSurvey(int id) => _service.deleteTask(id);


}