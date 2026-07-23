class Task {
  final String id;
  final String title;
  final String noteId;
  final DateTime dueAt;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.noteId,
    required this.dueAt,
    required this.isCompleted,
  });

  Task copyWith({bool? isCompleted}) {
    return Task(
      id: id,
      title: title,
      noteId: noteId,
      dueAt: dueAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}