import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/task.dart';

extension _TaskRowMapper on TaskRow {
  Task toDomain() {
    return Task(
      id: id,
      title: title,
      noteId: noteId,
      dueAt: dueAt,
      isCompleted: isCompleted,
    );
  }
}

class TaskRepository {
  final AppDatabase db;

  TaskRepository(this.db);

  Stream<List<Task>> watchAllTasks() {
    return db.select(db.tasks).watch().map(
          (rows) => rows.map((r) => r.toDomain()).toList(),
        );
  }

  Future<void> upsertTask(Task task) {
    return db.into(db.tasks).insertOnConflictUpdate(
          TasksCompanion.insert(
            id: task.id,
            title: task.title,
            noteId: task.noteId,
            dueAt: task.dueAt,
            isCompleted: Value(task.isCompleted),
          ),
        );
  }

  Future<void> deleteTask(String id) {
    return (db.delete(db.tasks)..where((t) => t.id.equals(id))).go();
  }

  Future<Task?> getTaskForNote(String noteId) async {
    final row = await (db.select(db.tasks)..where((t) => t.noteId.equals(noteId)))
        .getSingleOrNull();
    return row?.toDomain();
  }
}