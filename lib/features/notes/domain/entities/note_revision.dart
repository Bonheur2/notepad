class NoteRevision {
  final String id;
  final String noteId;
  final String title;
  final String contentMarkdown;
  final int version;
  final DateTime savedAt;

  const NoteRevision({
    required this.id,
    required this.noteId,
    required this.title,
    required this.contentMarkdown,
    required this.version,
    required this.savedAt,
  });
}