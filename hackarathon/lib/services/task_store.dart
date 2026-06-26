import '../models/task.dart';

abstract class TaskStore {
  Future<List<Task>> getTasks();

  Future<int> insertTask(Task task);

  Future<int> updateTaskStatus(int id, int status);

  Future<int> deleteTask(int id);
}
