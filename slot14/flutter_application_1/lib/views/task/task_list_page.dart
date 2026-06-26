import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/task_view_model.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TaskViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.tasks.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks yet. Add a new task!',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => viewModel.loadTasks(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: viewModel.tasks.length,
                    itemBuilder: (context, index) {
                      final task = viewModel.tasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.status == 1,
                            onChanged: (_) {
                              viewModel.toggleTaskStatus(task);
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: task.status == 1
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.description),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 14),
                                  const SizedBox(width: 4),
                                  Text(task.deadline),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: task.status == 1
                                          ? Colors.green.shade100
                                          : Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      task.status == 1
                                          ? 'Completed'
                                          : 'Pending',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: task.status == 1
                                            ? Colors.green.shade800
                                            : Colors.orange.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title:
                                      const Text('Delete Task'),
                                  content: Text(
                                      'Are you sure you want to delete "${task.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        viewModel.deleteTask(task.id!);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete',
                                          style:
                                              TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.addTask);
          viewModel.loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
