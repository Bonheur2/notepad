import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/core_providers.dart';
import '../../../../app/providers/note_providers.dart';
import '../../../../app/providers/sync_providers.dart';
import '../../../../app/widgets/empty_state.dart';
import '../../domain/entities/note.dart';
import 'note_editor_screen.dart';

const double _wideBreakpoint = 840;

class _NewNoteIntent extends Intent {
  const _NewNoteIntent();
}

class _FocusSearchIntent extends Intent {
  const _FocusSearchIntent();
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String? _activeTagFilter;

  String? _selectedNoteId;
  bool _showNewNoteInPanel = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _openNote(Note? note, {required bool isWide}) {
    if (isWide) {
      setState(() {
        _selectedNoteId = note?.id;
        _showNewNoteInPanel = note == null;
      });
    } else {
      context.push(note == null ? '/note' : '/note/${note.id}');
    }
  }

  bool _matchesSearch(Note n) {
    if (_searchQuery.isEmpty) return true;
    final haystack = '${n.title} ${n.contentMarkdown} ${n.tags.join(' ')}'.toLowerCase();
    return haystack.contains(_searchQuery);
  }

  bool _matchesTag(Note n) {
    if (_activeTagFilter == null) return true;
    return n.tags.contains(_activeTagFilter);
  }

  Widget _buildTabBarView(List<String> tabs, List<Note> allNotes, bool isWide) {
    return TabBarView(
      children: tabs.map((tab) {
        var filtered = tab == 'All'
            ? allNotes
            : allNotes.where((n) => (n.category.isEmpty ? 'General' : n.category) == tab).toList();

        filtered = filtered.where(_matchesSearch).where(_matchesTag).toList();

        if (filtered.isEmpty) {
          return EmptyState(
            icon: Icons.notes_outlined,
            message: allNotes.isEmpty
                ? 'No notes yet — tap + to create one.'
                : 'No matching notes.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
          itemCount: filtered.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final n = filtered[index];
            final selected = isWide && !_showNewNoteInPanel && _selectedNoteId == n.id;
            final colorScheme = Theme.of(context).colorScheme;
            return Card(
              color: selected ? colorScheme.primaryContainer.withValues(alpha: 0.4) : null,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _openNote(n, isWide: isWide),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (n.isEncrypted)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Icon(Icons.lock,
                                        size: 13, color: colorScheme.onSurfaceVariant),
                                  ),
                                Expanded(
                                  child: Text(
                                    n.isEncrypted ? 'Encrypted note' : n.contentMarkdown,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(n.category),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(allNotesProvider);
    final syncAsync = ref.watch(syncEngineProvider);
    ref.watch(notificationInitProvider);

    final allNotes = notesAsync.value ?? [];

    final categories = <String>{'All'};
    for (final n in allNotes) {
      categories.add(n.category.isEmpty ? 'General' : n.category);
    }
    final tabs = categories.toList();

    final allTags = <String>{};
    for (final n in allNotes) {
      allTags.addAll(n.tags);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _wideBreakpoint;

        return DefaultTabController(
          length: tabs.length,
          child: Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
                  const _NewNoteIntent(),
              LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
                  const _FocusSearchIntent(),
            },
            child: Actions(
              actions: {
                _NewNoteIntent: CallbackAction<_NewNoteIntent>(onInvoke: (_) {
                  _openNote(null, isWide: isWide);
                  return null;
                }),
                _FocusSearchIntent: CallbackAction<_FocusSearchIntent>(onInvoke: (_) {
                  _searchFocusNode.requestFocus();
                  return null;
                }),
              },
              child: Focus(
                autofocus: true,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Notes'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.person_outline),
                        tooltip: 'Account',
                        onPressed: () => context.push('/account'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        tooltip: 'Friends & Chats',
                        onPressed: () => context.push('/friends'),
                      ),
                      if (syncAsync.isLoading)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(96),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Search notes...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        tooltip: 'Clear search',
                                        onPressed: () => _searchController.clear(),
                                      )
                                    : null,
                                isDense: true,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          if (allTags.isNotEmpty)
                            SizedBox(
                              height: 36,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                children: allTags.map((tag) {
                                  final selected = _activeTagFilter == tag;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: FilterChip(
                                      label: Text(tag),
                                      selected: selected,
                                      onSelected: (_) {
                                        setState(() {
                                          _activeTagFilter = selected ? null : tag;
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            tabs: tabs.map((t) => Tab(text: t)).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: isWide
                      ? Row(
                          children: [
                            SizedBox(
                              width: 360,
                              child: _buildTabBarView(tabs, allNotes, isWide),
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(
                              child: (_showNewNoteInPanel || _selectedNoteId != null)
                                  ? NoteEditorScreen(
                                      key: ValueKey(
                                        _showNewNoteInPanel ? 'new' : _selectedNoteId,
                                      ),
                                      noteId: _showNewNoteInPanel ? null : _selectedNoteId,
                                      embedded: true,
                                      onDone: () => setState(() {
                                        _selectedNoteId = null;
                                        _showNewNoteInPanel = false;
                                      }),
                                    )
                                  : const EmptyState(
                                      icon: Icons.edit_note,
                                      message: 'Select a note or create a new one',
                                    ),
                            ),
                          ],
                        )
                      : _buildTabBarView(tabs, allNotes, isWide),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () => _openNote(null, isWide: isWide),
                    tooltip: 'New note',
                    icon: const Icon(Icons.add),
                    label: const Text('New note'),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
