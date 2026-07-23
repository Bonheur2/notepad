import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/note_revision.dart';

extension _RevisionRowMapper on NoteRevisionRow {
  NoteRevision toDomain() {
    return NoteRevision(
      id: id,
      noteId: noteId,
      title: title,
      contentMarkdown: contentMarkdown,
      version: version,
      savedAt: savedAt,
    );
  }
}

class NoteRevisionRepository {
  final AppDatabase db;

  NoteRevisionRepository(this.db);

  Future<void> saveRevision({
    required String noteId,
    required String title,
    required String contentMarkdown,
    required int version,
  }) {
    return db.into(db.noteRevisions).insert(
          NoteRevisionsCompanion.insert(
            id: const Uuid().v4(),
            noteId: noteId,
            title: title,
            contentMarkdown: contentMarkdown,
            version: version,
            savedAt: DateTime.now(),
          ),
        );
  }

  Stream<List<NoteRevision>> watchRevisionsForNote(String noteId) {
    final query = db.select(db.noteRevisions)
      ..where((r) => r.noteId.equals(noteId))
      ..orderBy([(r) => OrderingTerm.desc(r.savedAt)]);
    return query.watch().map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Future<void> deleteRevisionsForNote(String noteId) {
    return (db.delete(db.noteRevisions)..where((r) => r.noteId.equals(noteId))).go();
  }
}