import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/note.dart';
import '../../data/repositories/note_repository.dart';
import '../../../../core/sync/sync_engine.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteRepository repo;
  final SyncEngine? syncEngine;
  final Note? existingNote;

  const NoteEditorScreen({
    super.key,
    required this.repo,
    this.syncEngine,
    this.existingNote,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _categoryController;

  bool get isEditing => widget.existingNote != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController = TextEditingController(text: widget.existingNote?.contentMarkdown ?? '');
    _categoryController = TextEditingController(text: widget.existingNote?.category ?? 'General');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final now = DateTime.now();
    final title = _titleController.text.trim().isEmpty
        ? 'Untitled'
        : _titleController.text.trim();
    final category = _categoryController.text.trim().isEmpty
        ? 'General'
        : _categoryController.text.trim();

    final note = Note(
      id: widget.existingNote?.id ?? const Uuid().v4(),
      title: title,
      contentMarkdown: _contentController.text,
      tags: widget.existingNote?.tags ?? [],
      category: category,
      isEncrypted: widget.existingNote?.isEncrypted ?? false,
      createdAt: widget.existingNote?.createdAt ?? now,
      updatedAt: now,
      version: (widget.existingNote?.version ?? 0) + 1,
      linkedTaskId: widget.existingNote?.linkedTaskId,
    );

    await widget.repo.upsertNote(note);
    await widget.syncEngine?.pushNote(note);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    if (widget.existingNote == null) return;
    final id = widget.existingNote!.id;
    await widget.repo.deleteNote(id);
    await widget.syncEngine?.deleteRemoteNote(id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
          ],
        ),
      ),
    );
  }
}