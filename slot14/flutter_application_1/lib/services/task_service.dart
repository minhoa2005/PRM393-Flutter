import '../data/task_database.dart';
import '../models/task_model.dart';

class TaskService {
  final TaskDatabase _db = TaskDatabase.instance;

  Future<int> addTask(TaskModel task) async {
    return await _db.insert(task);
  }

  Future<List<TaskModel>> getAllTasks() async {
    return await _db.getAll();
  }

  Future<int> updateTask(TaskModel task) async {
    return await _db.update(task);
  }

  Future<int> deleteTask(int id) async {
    return await _db.delete(id);
  }

  Future<int> getTotalTasks() async {
    final tasks = await _db.getAll();
    return tasks.length;
  }

  Future<int> getCompletedTasks() async {
    final tasks = await _db.getAll();
    return tasks.where((task) => task.status == 1).length;
  }

  Future<int> getPendingTasks() async {
    final tasks = await _db.getAll();
    return tasks.where((task) => task.status == 0).length;
  }
}
