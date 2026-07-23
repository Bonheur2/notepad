import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../../domain/entities/note.dart';
import '../../domain/entities/note_revision.dart';
import '../../../../app/providers/core_providers.dart';
import '../../../../app/providers/note_providers.dart';
import '../../../../app/providers/sync_providers.dart';
import '../../../tasks/domain/entities/task.dart';

class _SaveIntent extends Intent {
  const _SaveIntent();
}

class NoteEditorScreen extends ConsumerStatefulWidget {
  final String? noteId;
  final bool embedded;
  final VoidCallback? onDone;

  const NoteEditorScreen({
    super.key,
    this.noteId,
    this.embedded = false,
    this.onDone,
  });

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _categoryController;
  late final TextEditingController _tagsController;

  late final _repo = ref.read(noteRepositoryProvider);
  late final _encryptionService = ref.read(encryptionServiceProvider);
  late final _exportService = ref.read(exportServiceProvider);
  late final _voiceService = ref.read(voiceInputServiceProvider);
  late final _taskRepo = ref.read(taskRepositoryProvider);
  late final _revisionRepo = ref.read(noteRevisionRepositoryProvider);
  late final _notificationService = ref.read(notificationServiceProvider);

  Note? _existingNote;
  bool _isEncrypted = false;
  bool _loading = true;
  bool _isListening = false;
  DateTime? _reminderAt;
  Task? _existingTask;
  String? _sketchPath;

  bool get isEditing => widget.noteId != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _categoryController = TextEditingController(text: 'General');
    _tagsController = TextEditingController();
    _contentController = TextEditingController();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final id = widget.noteId;
    if (id == null) {
      setState(() => _loading = false);
      return;
    }

    final note = await ref.read(noteByIdProvider(id).future);
    _existingNote = note;
    if (note != null) {
      _titleController.text = note.title;
      _categoryController.text = note.category;
      _tagsController.text = note.tags.join(', ');
      _isEncrypted = note.isEncrypted;
      _sketchPath = note.sketchPath;

      if (note.isEncrypted) {
        try {
          final decrypted = await _encryptionService.decrypt(note.contentMarkdown);
          _contentController.text = decrypted;
        } catch (_) {
          _contentController.text = '⚠️ Could not decrypt this note on this device.';
        }
      } else {
        _contentController.text = note.contentMarkdown;
      }

      await _loadExistingTask(note.id);
    }

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadExistingTask(String noteId) async {
    final task = await _taskRepo.getTaskForNote(noteId);
    if (task != null && mounted) {
      setState(() {
        _existingTask = task;
        _reminderAt = task.dueAt;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  List<String> _parseTags() {
    return _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
      return;
    }

    final baseText = _contentController.text;
    final needsSpace = baseText.isNotEmpty &&
        !baseText.endsWith(' ') &&
        !baseText.endsWith('\n');
    final prefix = needsSpace ? '$baseText ' : baseText;

    setState(() => _isListening = true);
    await _voiceService.startListening(
      onResult: (recognized) {
        _contentController.text = '$prefix$recognized';
        _contentController.selection = TextSelection.collapsed(
          offset: _contentController.text.length,
        );
      },
    );
  }

  Future<void> _pickReminder() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _reminderAt ?? DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_reminderAt ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      _reminderAt =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _saveReminder(String noteId, String title) async {
    if (_reminderAt == null) {
      if (_existingTask != null) {
        await _taskRepo.deleteTask(_existingTask!.id);
        await _notificationService.cancelReminder(_existingTask!.id);
      }
      return;
    }

    final task = Task(
      id: _existingTask?.id ?? const Uuid().v4(),
      title: title,
      noteId: noteId,
      dueAt: _reminderAt!,
      isCompleted: false,
    );
    await _taskRepo.upsertTask(task);
    await _notificationService.scheduleReminder(
      taskId: task.id,
      title: title,
      dueAt: task.dueAt,
    );
  }

  Future<void> _handleExport(String format) async {
    final title = _titleController.text.trim().isEmpty
        ? 'Untitled'
        : _titleController.text.trim();
    final content = _contentController.text;

    switch (format) {
      case 'markdown':
        await _exportService.exportMarkdown(title, content);
        break;
      case 'pdf':
        await _exportService.exportPdf(title, content);
        break;
      case 'docx':
        await _exportService.exportDocx(title, content);
        break;
    }
  }

  Future<void> _openHistory() async {
    if (widget.noteId == null) return;

    final selected = await context.push<NoteRevision>(
      '/note/${widget.noteId}/history',
    );

    if (selected == null || !mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restore v${selected.version}?'),
        content: Text(
          'This will replace your current title and content with the version saved on '
          '${selected.savedAt.toLocal().toString().split('.').first}. '
          'Your current unsaved changes will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _titleController.text = selected.title;
        _contentController.text = selected.contentMarkdown;
      });
    }
  }

  Future<void> _openHandwriting() async {
    final idSegment = widget.noteId ?? 'new';
    final result = await context.push<String?>(
      '/note/$idSegment/sketch',
      extra: _sketchPath,
    );
    if (result != null) {
      setState(() => _sketchPath = result);
    }
  }

  Future<void> _save() async {
    if (_isListening) await _voiceService.stopListening();

    final now = DateTime.now();
    final title = _titleController.text.trim().isEmpty
        ? 'Untitled'
        : _titleController.text.trim();
    final category = _categoryController.text.trim().isEmpty
        ? 'General'
        : _categoryController.text.trim();

    final rawContent = _contentController.text;
    final storedContent = _isEncrypted
        ? await _encryptionService.encrypt(rawContent)
        : rawContent;

    final noteId = _existingNote?.id ?? widget.noteId ?? const Uuid().v4();
    final newVersion = (_existingNote?.version ?? 0) + 1;

    // Archive the PREVIOUS state as a revision before overwriting, if editing.
    if (_existingNote != null) {
      await _revisionRepo.saveRevision(
        noteId: noteId,
        title: _existingNote!.title,
        contentMarkdown: _existingNote!.isEncrypted
            ? '🔒 (was encrypted at this revision)'
            : _existingNote!.contentMarkdown,
        version: _existingNote!.version,
      );
    }

    final note = Note(
      id: noteId,
      title: title,
      contentMarkdown: storedContent,
      tags: _parseTags(),
      category: category,
      isEncrypted: _isEncrypted,
      createdAt: _existingNote?.createdAt ?? now,
      updatedAt: now,
      version: newVersion,
      linkedTaskId: _existingNote?.linkedTaskId,
      sketchPath: _sketchPath,
    );
    await _repo.upsertNote(note);
    await ref.read(syncEngineProvider).valueOrNull?.pushNote(note);
    await _saveReminder(noteId, title);
    ref.invalidate(noteByIdProvider(noteId));

    if (mounted) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      widget.onDone?.call();
    }
  }

  Future<void> _delete() async {
    final id = _existingNote?.id ?? widget.noteId;
    if (id == null) return;
    await _repo.deleteNote(id);
    await ref.read(syncEngineProvider).valueOrNull?.deleteRemoteNote(id);
    await _revisionRepo.deleteRevisionsForNote(id);
    if (_existingTask != null) {
      await _taskRepo.deleteTask(_existingTask!.id);
      await _notificationService.cancelReminder(_existingTask!.id);
    }
    ref.invalidate(noteByIdProvider(id));

    if (mounted) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      widget.onDone?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final scaffold = Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Version history',
              onPressed: _openHistory,
            ),
          IconButton(
            icon: const Icon(Icons.draw_outlined),
            tooltip: 'Handwriting',
            onPressed: _openHandwriting,
          ),
          IconButton(
            icon: Icon(_isEncrypted ? Icons.lock : Icons.lock_open),
            tooltip: _isEncrypted
                ? 'Encrypted — tap to disable'
                : 'Not encrypted — tap to enable',
            onPressed: () => setState(() => _isEncrypted = !_isEncrypted),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.ios_share),
            tooltip: 'Export',
            onSelected: _handleExport,
            itemBuilder: (context) => const [
              PopupMenuItem(
                  value: 'markdown', child: Text('Export as Markdown')),
              PopupMenuItem(value: 'pdf', child: Text('Export as PDF')),
              PopupMenuItem(
                  value: 'docx', child: Text('Export as Word (.docx)')),
            ],
          ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete note',
              onPressed: _delete,
            ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save note',
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isEncrypted)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock,
                        size: 14,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    const SizedBox(width: 6),
                    Text(
                      'This note is encrypted on this device',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            TextField(
              controller: _titleController,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: _categoryController,
              style: Theme.of(context).textTheme.bodySmall,
              decoration: const InputDecoration(
                hintText: 'Category (e.g. Work, Personal, Ideas)',
                prefixIcon: Icon(Icons.folder_outlined, size: 18),
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: _tagsController,
              style: Theme.of(context).textTheme.bodySmall,
              decoration: const InputDecoration(
                hintText: 'Tags, comma separated (e.g. urgent, recipe)',
                prefixIcon: Icon(Icons.label_outline, size: 18),
                border: InputBorder.none,
              ),
            ),
            InkWell(
              onTap: _pickReminder,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.alarm, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _reminderAt == null
                          ? 'Set reminder'
                          : 'Reminder: ${_reminderAt!.toLocal()}'
                              .split('.')
                              .first,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (_reminderAt != null)
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        tooltip: 'Clear reminder',
                        onPressed: () => setState(() => _reminderAt = null),
                      ),
                  ],
                ),
              ),
            ),
            if (_sketchPath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_sketchPath!),
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        tooltip: 'Remove sketch',
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.black45,
                            foregroundColor: Colors.white),
                        onPressed: () => setState(() => _sketchPath = null),
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_isListening)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic,
                        size: 14, color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 6),
                    Text(
                      'Listening...',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleListening,
        tooltip: _isListening ? 'Stop dictation' : 'Start dictation',
        backgroundColor:
            _isListening ? Theme.of(context).colorScheme.error : null,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const _SaveIntent(),
      },
      child: Actions(
        actions: {
          _SaveIntent: CallbackAction<_SaveIntent>(onInvoke: (_) {
            _save();
            return null;
          }),
        },
        child: Focus(autofocus: true, child: scaffold),
      ),
    );
  }
}
