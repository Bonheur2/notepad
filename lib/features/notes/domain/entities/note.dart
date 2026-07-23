class Note {
  final String id;
  final String title;
  final String contentMarkdown;
  final List<String> tags;
  final String category;
  final bool isEncrypted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final String? linkedTaskId;
  final String? sketchPath;

  const Note({
    required this.id,
    required this.title,
    required this.contentMarkdown,
    required this.tags,
    required this.category,
    required this.isEncrypted,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.linkedTaskId,
    this.sketchPath,
  });

  Note copyWith({
    String? title,
    String? contentMarkdown,
    List<String>? tags,
    String? category,
    bool? isEncrypted,
    DateTime? updatedAt,
    int? version,
    String? linkedTaskId,
    String? sketchPath,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      contentMarkdown: contentMarkdown ?? this.contentMarkdown,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      linkedTaskId: linkedTaskId ?? this.linkedTaskId,
      sketchPath: sketchPath ?? this.sketchPath,
    );
  }
}