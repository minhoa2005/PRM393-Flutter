import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_manager/models/task.dart';

void main() {
  test('Task converts to and from a SQLite map', () {
    final task = Task(
      id: 7,
      title: 'Math homework',
      description: 'Finish chapter 3 exercises',
      deadline: '2026-06-30',
      status: 1,
    );

    final map = task.toMap();
    final restored = Task.fromMap(map);

    expect(restored.id, 7);
    expect(restored.title, 'Math homework');
    expect(restored.description, 'Finish chapter 3 exercises');
    expect(restored.deadline, '2026-06-30');
    expect(restored.status, 1);
    expect(restored.isCompleted, isTrue);
    expect(restored.statusText, 'Completed');
  });

  test('Task defaults to pending', () {
    final task = Task(
      title: 'Read Flutter docs',
      description: 'Review state management',
      deadline: '2026-07-01',
    );

    expect(task.status, 0);
    expect(task.isCompleted, isFalse);
    expect(task.statusText, 'Pending');
  });
}
