import 'dart:async';
import '../../features/notes/domain/entities/note.dart';
import '../../features/notes/data/repositories/note_repository.dart';
import '../../features/notes/data/datasources/note_remote_datasource.dart';

class SyncEngine {
  final NoteRepository localRepo;
  final NoteRemoteDataSource remoteDataSource;
  StreamSubscription<List<Note>>? _remoteSub;

  SyncEngine({required this.localRepo, required this.remoteDataSource});

  void startListening() {
    _remoteSub = remoteDataSource.watchRemoteNotes().listen((remoteNotes) async {
      final localNotes = await localRepo.getAllNotes();
      final localById = {for (final n in localNotes) n.id: n};

      for (final remote in remoteNotes) {
        final local = localById[remote.id];
        // Last-write-wins: only apply remote if it's newer than what we have locally
        if (local == null || remote.updatedAt.isAfter(local.updatedAt)) {
          await localRepo.upsertNote(remote);
        }
      }
    });
  }

  Future<void> pushNote(Note note) => remoteDataSource.pushNote(note);

  Future<void> deleteRemoteNote(String id) => remoteDataSource.deleteNote(id);

  void dispose() {
    _remoteSub?.cancel();
  }
}