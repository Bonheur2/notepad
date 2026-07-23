import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/sync/sync_engine.dart';
import '../../features/notes/data/datasources/note_remote_datasource.dart';
import 'core_providers.dart';

final syncEngineProvider = FutureProvider<SyncEngine>((ref) async {
  final uid = await ref.watch(authServiceProvider).ensureSignedIn();
  final engine = SyncEngine(
    localRepo: ref.watch(noteRepositoryProvider),
    remoteDataSource: NoteRemoteDataSource(uid),
  );
  engine.startListening();
  ref.onDispose(engine.dispose);
  return engine;
});
