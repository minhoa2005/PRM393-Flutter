import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _taskService.getAllTasks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await _taskService.addTask(task);
    await loadTasks();
  }

  Future<void> toggleTaskStatus(TaskModel task) async {
    final updatedTask = task.copyWith(
      status: task.status == 0 ? 1 : 0,
    );
    await _taskService.updateTask(updatedTask);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
    await loadTasks();
  }
}
