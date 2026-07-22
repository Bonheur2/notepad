import '../../../../core/database/app_database.dart';
import '../../domain/entities/note.dart';
import '../mappers/note_mapper.dart';

class NoteRepository {
  final AppDatabase db;

  NoteRepository(this.db);

  Future<List<Note>> getAllNotes() async {
    final rows = await db.select(db.notes).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  Stream<List<Note>> watchAllNotes() {
    return db.select(db.notes).watch().map(
          (rows) => rows.map((r) => r.toDomain()).toList(),
        );
  }

  Future<void> upsertNote(Note note) {
    return db.into(db.notes).insertOnConflictUpdate(note.toCompanion());
  }

  Future<void> deleteNote(String id) {
    return (db.delete(db.notes)..where((t) => t.id.equals(id))).go();
  }
}