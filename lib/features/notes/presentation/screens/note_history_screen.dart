import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note_revision.dart';
import '../../../../app/providers/core_providers.dart';

class NoteHistoryScreen extends ConsumerWidget {
  final String noteId;

  const NoteHistoryScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revisionRepo = ref.watch(noteRevisionRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Version History')),
      body: StreamBuilder<List<NoteRevision>>(
        stream: revisionRepo.watchRevisionsForNote(noteId),
        builder: (context, snapshot) {
          final revisions = snapshot.data ?? [];
          if (revisions.isEmpty) {
            return const Center(
              child: Text(
                  'No earlier versions yet.\nEdit and save this note to start building history.'),
            );
          }
          return ListView.builder(
            itemCount: revisions.length,
            itemBuilder: (context, index) {
              final rev = revisions[index];
              return ListTile(
                leading: CircleAvatar(child: Text('v${rev.version}')),
                title: Text(rev.title),
                subtitle:
                    Text(rev.savedAt.toLocal().toString().split('.').first),
                onTap: () => Navigator.of(context).pop(rev),
              );
            },
          );
        },
      ),
    );
  }
}
