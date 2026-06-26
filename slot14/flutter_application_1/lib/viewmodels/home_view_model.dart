import 'package:flutter/material.dart';
import '../services/task_service.dart';

class HomeViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  int _totalTasks = 0;
  int _completedTasks = 0;
  int _pendingTasks = 0;

  int get totalTasks => _totalTasks;
  int get completedTasks => _completedTasks;
  int get pendingTasks => _pendingTasks;

  Future<void> loadStatistics() async {
    _totalTasks = await _taskService.getTotalTasks();
    _completedTasks = await _taskService.getCompletedTasks();
    _pendingTasks = await _taskService.getPendingTasks();
    notifyListeners();
  }
}
