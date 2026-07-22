import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import '../core/database/app_database.dart';
import '../core/auth/auth_service.dart';
import '../core/sync/sync_engine.dart';
import '../features/notes/domain/entities/note.dart';
import '../features/notes/data/repositories/note_repository.dart';
import '../features/notes/data/datasources/note_remote_datasource.dart';
import '../features/notes/presentation/screens/note_editor_screen.dart';

class NotepadApp extends StatelessWidget {
  const NotepadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notepad',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = AppDatabase();
  late final repo = NoteRepository(db);
  final authService = AuthService();

  SyncEngine? syncEngine;
  bool _syncReady = false;

  @override
  void initState() {
    super.initState();
    _initSync();
  }

  Future<void> _initSync() async {
    final uid = await authService.ensureSignedIn();
    final remoteDataSource = NoteRemoteDataSource(uid);
    syncEngine = SyncEngine(localRepo: repo, remoteDataSource: remoteDataSource);
    syncEngine!.startListening();
    if (mounted) setState(() => _syncReady = true);
  }

  @override
  void dispose() {
    syncEngine?.dispose();
    super.dispose();
  }

  void _openEditor({Note? note}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(
          repo: repo,
          syncEngine: syncEngine,
          existingNote: note,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: repo.watchAllNotes(),
      builder: (context, snapshot) {
        final notes = snapshot.data ?? [];

        final categories = <String>{'All'};
        for (final n in notes) {
          categories.add(n.category.isEmpty ? 'General' : n.category);
        }
        final tabs = categories.toList();

        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Notes'),
              actions: [
                if (!_syncReady)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: tabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
            body: TabBarView(
              children: tabs.map((tab) {
                final filtered = tab == 'All'
                    ? notes
                    : notes.where((n) => (n.category.isEmpty ? 'General' : n.category) == tab).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No notes here yet.'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final n = filtered[index];
                    return ListTile(
                      title: Text(n.title),
                      subtitle: Text(
                        n.contentMarkdown,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Chip(
                        label: Text(n.category, style: const TextStyle(fontSize: 10)),
                        padding: EdgeInsets.zero,
                      ),
                      onTap: () => _openEditor(note: n),
                    );
                  },
                );
              }).toList(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _openEditor(),
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}