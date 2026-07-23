import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/notes/domain/entities/note.dart';
import 'core_providers.dart';

final allNotesProvider = StreamProvider<List<Note>>(
  (ref) => ref.watch(noteRepositoryProvider).watchAllNotes(),
);

final noteByIdProvider = FutureProvider.family<Note?, String>(
  (ref, id) => ref.watch(noteRepositoryProvider).getNoteById(id),
);
