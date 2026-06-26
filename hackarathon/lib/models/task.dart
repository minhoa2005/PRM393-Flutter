class Task {
  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.status = 0,
  });

  final int? id;
  final String title;
  final String description;
  final String deadline;
  final int status;

  bool get isCompleted => status == 1;

  String get statusText => isCompleted ? 'Completed' : 'Pending';

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? deadline,
    int? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
    );
  }

  Map<String, Object?> toMap({bool includeId = true}) {
    final map = <String, Object?>{
      'title': title,
      'description': description,
      'deadline': deadline,
      'status': status,
    };

    if (includeId && id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Task.fromMap(Map<String, Object?> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      deadline: map['deadline'] as String,
      status: map['status'] as int,
    );
  }
}
