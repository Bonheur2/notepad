import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/note.dart';

extension NoteMapper on Note {
  NotesCompanion toCompanion() {
    return NotesCompanion.insert(
      id: id,
      title: Value(title),
      contentMarkdown: Value(contentMarkdown),
      tags: Value(tags.join(',')),
      category: Value(category),
      isEncrypted: Value(isEncrypted),
      createdAt: createdAt,
      updatedAt: updatedAt,
      version: Value(version),
      linkedTaskId: Value(linkedTaskId),
    );
  }
}

extension NoteRowMapper on NoteRow {
  Note toDomain() {
    return Note(
      id: id,
      title: title,
      contentMarkdown: contentMarkdown,
      tags: tags.isEmpty ? [] : tags.split(','),
      category: category,
      isEncrypted: isEncrypted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      version: version,
      linkedTaskId: linkedTaskId,
    );
  }
}