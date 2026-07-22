import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/note.dart';

class NoteRemoteDataSource {
  final String uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NoteRemoteDataSource(this.uid);

  CollectionReference<Map<String, dynamic>> get _notesRef =>
      _firestore.collection('users').doc(uid).collection('notes');

  Future<void> pushNote(Note note) {
    return _notesRef.doc(note.id).set({
      'title': note.title,
      'contentMarkdown': note.contentMarkdown,
      'tags': note.tags,
      'category': note.category,
      'isEncrypted': note.isEncrypted,
      'createdAt': note.createdAt.toIso8601String(),
      'updatedAt': note.updatedAt.toIso8601String(),
      'version': note.version,
      'linkedTaskId': note.linkedTaskId,
    });
  }

  Future<void> deleteNote(String id) {
    return _notesRef.doc(id).delete();
  }

  Stream<List<Note>> watchRemoteNotes() {
    return _notesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Note(
          id: doc.id,
          title: data['title'] ?? '',
          contentMarkdown: data['contentMarkdown'] ?? '',
          tags: List<String>.from(data['tags'] ?? []),
          category: data['category'] ?? 'General',
          isEncrypted: data['isEncrypted'] ?? false,
          createdAt: DateTime.parse(data['createdAt']),
          updatedAt: DateTime.parse(data['updatedAt']),
          version: data['version'] ?? 1,
          linkedTaskId: data['linkedTaskId'],
        );
      }).toList();
    });
  }
}