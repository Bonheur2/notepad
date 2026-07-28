import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note_revision.dart';
import '../../../../app/providers/core_providers.dart';
import '../../../../app/widgets/empty_state.dart';

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
            return const EmptyState(
              icon: Icons.history,
              message:
                  'No earlier versions yet.\nEdit and save this note to start building history.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: revisions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final rev = revisions[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      'v${rev.version}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(rev.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle:
                      Text(rev.savedAt.toLocal().toString().split('.').first),
                  onTap: () => Navigator.of(context).pop(rev),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
