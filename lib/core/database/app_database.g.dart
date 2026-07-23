// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NotesTable extends Notes with TableInfo<$NotesTable, NoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _contentMarkdownMeta =
      const VerificationMeta('contentMarkdown');
  @override
  late final GeneratedColumn<String> contentMarkdown = GeneratedColumn<String>(
      'content_markdown', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('General'));
  static const VerificationMeta _isEncryptedMeta =
      const VerificationMeta('isEncrypted');
  @override
  late final GeneratedColumn<bool> isEncrypted = GeneratedColumn<bool>(
      'is_encrypted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_encrypted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _linkedTaskIdMeta =
      const VerificationMeta('linkedTaskId');
  @override
  late final GeneratedColumn<String> linkedTaskId = GeneratedColumn<String>(
      'linked_task_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sketchPathMeta =
      const VerificationMeta('sketchPath');
  @override
  late final GeneratedColumn<String> sketchPath = GeneratedColumn<String>(
      'sketch_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        contentMarkdown,
        tags,
        category,
        isEncrypted,
        createdAt,
        updatedAt,
        version,
        linkedTaskId,
        sketchPath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<NoteRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('content_markdown')) {
      context.handle(
          _contentMarkdownMeta,
          contentMarkdown.isAcceptableOrUnknown(
              data['content_markdown']!, _contentMarkdownMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('is_encrypted')) {
      context.handle(
          _isEncryptedMeta,
          isEncrypted.isAcceptableOrUnknown(
              data['is_encrypted']!, _isEncryptedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('linked_task_id')) {
      context.handle(
          _linkedTaskIdMeta,
          linkedTaskId.isAcceptableOrUnknown(
              data['linked_task_id']!, _linkedTaskIdMeta));
    }
    if (data.containsKey('sketch_path')) {
      context.handle(
          _sketchPathMeta,
          sketchPath.isAcceptableOrUnknown(
              data['sketch_path']!, _sketchPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      contentMarkdown: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}content_markdown'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      isEncrypted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_encrypted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      linkedTaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}linked_task_id']),
      sketchPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sketch_path']),
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class NoteRow extends DataClass implements Insertable<NoteRow> {
  final String id;
  final String title;
  final String contentMarkdown;
  final String tags;
  final String category;
  final bool isEncrypted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final String? linkedTaskId;
  final String? sketchPath;
  const NoteRow(
      {required this.id,
      required this.title,
      required this.contentMarkdown,
      required this.tags,
      required this.category,
      required this.isEncrypted,
      required this.createdAt,
      required this.updatedAt,
      required this.version,
      this.linkedTaskId,
      this.sketchPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content_markdown'] = Variable<String>(contentMarkdown);
    map['tags'] = Variable<String>(tags);
    map['category'] = Variable<String>(category);
    map['is_encrypted'] = Variable<bool>(isEncrypted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || linkedTaskId != null) {
      map['linked_task_id'] = Variable<String>(linkedTaskId);
    }
    if (!nullToAbsent || sketchPath != null) {
      map['sketch_path'] = Variable<String>(sketchPath);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      contentMarkdown: Value(contentMarkdown),
      tags: Value(tags),
      category: Value(category),
      isEncrypted: Value(isEncrypted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      linkedTaskId: linkedTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTaskId),
      sketchPath: sketchPath == null && nullToAbsent
          ? const Value.absent()
          : Value(sketchPath),
    );
  }

  factory NoteRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      contentMarkdown: serializer.fromJson<String>(json['contentMarkdown']),
      tags: serializer.fromJson<String>(json['tags']),
      category: serializer.fromJson<String>(json['category']),
      isEncrypted: serializer.fromJson<bool>(json['isEncrypted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      linkedTaskId: serializer.fromJson<String?>(json['linkedTaskId']),
      sketchPath: serializer.fromJson<String?>(json['sketchPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'contentMarkdown': serializer.toJson<String>(contentMarkdown),
      'tags': serializer.toJson<String>(tags),
      'category': serializer.toJson<String>(category),
      'isEncrypted': serializer.toJson<bool>(isEncrypted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'linkedTaskId': serializer.toJson<String?>(linkedTaskId),
      'sketchPath': serializer.toJson<String?>(sketchPath),
    };
  }

  NoteRow copyWith(
          {String? id,
          String? title,
          String? contentMarkdown,
          String? tags,
          String? category,
          bool? isEncrypted,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? version,
          Value<String?> linkedTaskId = const Value.absent(),
          Value<String?> sketchPath = const Value.absent()}) =>
      NoteRow(
        id: id ?? this.id,
        title: title ?? this.title,
        contentMarkdown: contentMarkdown ?? this.contentMarkdown,
        tags: tags ?? this.tags,
        category: category ?? this.category,
        isEncrypted: isEncrypted ?? this.isEncrypted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        version: version ?? this.version,
        linkedTaskId:
            linkedTaskId.present ? linkedTaskId.value : this.linkedTaskId,
        sketchPath: sketchPath.present ? sketchPath.value : this.sketchPath,
      );
  NoteRow copyWithCompanion(NotesCompanion data) {
    return NoteRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      contentMarkdown: data.contentMarkdown.present
          ? data.contentMarkdown.value
          : this.contentMarkdown,
      tags: data.tags.present ? data.tags.value : this.tags,
      category: data.category.present ? data.category.value : this.category,
      isEncrypted:
          data.isEncrypted.present ? data.isEncrypted.value : this.isEncrypted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      linkedTaskId: data.linkedTaskId.present
          ? data.linkedTaskId.value
          : this.linkedTaskId,
      sketchPath:
          data.sketchPath.present ? data.sketchPath.value : this.sketchPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('contentMarkdown: $contentMarkdown, ')
          ..write('tags: $tags, ')
          ..write('category: $category, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('linkedTaskId: $linkedTaskId, ')
          ..write('sketchPath: $sketchPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, contentMarkdown, tags, category,
      isEncrypted, createdAt, updatedAt, version, linkedTaskId, sketchPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.contentMarkdown == this.contentMarkdown &&
          other.tags == this.tags &&
          other.category == this.category &&
          other.isEncrypted == this.isEncrypted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.linkedTaskId == this.linkedTaskId &&
          other.sketchPath == this.sketchPath);
}

class NotesCompanion extends UpdateCompanion<NoteRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> contentMarkdown;
  final Value<String> tags;
  final Value<String> category;
  final Value<bool> isEncrypted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String?> linkedTaskId;
  final Value<String?> sketchPath;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.contentMarkdown = const Value.absent(),
    this.tags = const Value.absent(),
    this.category = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.linkedTaskId = const Value.absent(),
    this.sketchPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    this.title = const Value.absent(),
    this.contentMarkdown = const Value.absent(),
    this.tags = const Value.absent(),
    this.category = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.linkedTaskId = const Value.absent(),
    this.sketchPath = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NoteRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? contentMarkdown,
    Expression<String>? tags,
    Expression<String>? category,
    Expression<bool>? isEncrypted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? linkedTaskId,
    Expression<String>? sketchPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (contentMarkdown != null) 'content_markdown': contentMarkdown,
      if (tags != null) 'tags': tags,
      if (category != null) 'category': category,
      if (isEncrypted != null) 'is_encrypted': isEncrypted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (linkedTaskId != null) 'linked_task_id': linkedTaskId,
      if (sketchPath != null) 'sketch_path': sketchPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? contentMarkdown,
      Value<String>? tags,
      Value<String>? category,
      Value<bool>? isEncrypted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? version,
      Value<String?>? linkedTaskId,
      Value<String?>? sketchPath,
      Value<int>? rowid}) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      contentMarkdown: contentMarkdown ?? this.contentMarkdown,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      linkedTaskId: linkedTaskId ?? this.linkedTaskId,
      sketchPath: sketchPath ?? this.sketchPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentMarkdown.present) {
      map['content_markdown'] = Variable<String>(contentMarkdown.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isEncrypted.present) {
      map['is_encrypted'] = Variable<bool>(isEncrypted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (linkedTaskId.present) {
      map['linked_task_id'] = Variable<String>(linkedTaskId.value);
    }
    if (sketchPath.present) {
      map['sketch_path'] = Variable<String>(sketchPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('contentMarkdown: $contentMarkdown, ')
          ..write('tags: $tags, ')
          ..write('category: $category, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('linkedTaskId: $linkedTaskId, ')
          ..write('sketchPath: $sketchPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
      'note_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, title, noteId, dueAt, isCompleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<TaskRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_id'])!,
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String title;
  final String noteId;
  final DateTime dueAt;
  final bool isCompleted;
  const TaskRow(
      {required this.id,
      required this.title,
      required this.noteId,
      required this.dueAt,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['note_id'] = Variable<String>(noteId);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      noteId: Value(noteId),
      dueAt: Value(dueAt),
      isCompleted: Value(isCompleted),
    );
  }

  factory TaskRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      noteId: serializer.fromJson<String>(json['noteId']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'noteId': serializer.toJson<String>(noteId),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  TaskRow copyWith(
          {String? id,
          String? title,
          String? noteId,
          DateTime? dueAt,
          bool? isCompleted}) =>
      TaskRow(
        id: id ?? this.id,
        title: title ?? this.title,
        noteId: noteId ?? this.noteId,
        dueAt: dueAt ?? this.dueAt,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('noteId: $noteId, ')
          ..write('dueAt: $dueAt, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, noteId, dueAt, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.noteId == this.noteId &&
          other.dueAt == this.dueAt &&
          other.isCompleted == this.isCompleted);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> noteId;
  final Value<DateTime> dueAt;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.noteId = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    required String noteId,
    required DateTime dueAt,
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        noteId = Value(noteId),
        dueAt = Value(dueAt);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? noteId,
    Expression<DateTime>? dueAt,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (noteId != null) 'note_id': noteId,
      if (dueAt != null) 'due_at': dueAt,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? noteId,
      Value<DateTime>? dueAt,
      Value<bool>? isCompleted,
      Value<int>? rowid}) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      noteId: noteId ?? this.noteId,
      dueAt: dueAt ?? this.dueAt,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('noteId: $noteId, ')
          ..write('dueAt: $dueAt, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteRevisionsTable extends NoteRevisions
    with TableInfo<$NoteRevisionsTable, NoteRevisionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteRevisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
      'note_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMarkdownMeta =
      const VerificationMeta('contentMarkdown');
  @override
  late final GeneratedColumn<String> contentMarkdown = GeneratedColumn<String>(
      'content_markdown', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _savedAtMeta =
      const VerificationMeta('savedAt');
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
      'saved_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, noteId, title, contentMarkdown, version, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_revisions';
  @override
  VerificationContext validateIntegrity(Insertable<NoteRevisionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_markdown')) {
      context.handle(
          _contentMarkdownMeta,
          contentMarkdown.isAcceptableOrUnknown(
              data['content_markdown']!, _contentMarkdownMeta));
    } else if (isInserting) {
      context.missing(_contentMarkdownMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(_savedAtMeta,
          savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta));
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteRevisionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRevisionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      contentMarkdown: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}content_markdown'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      savedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}saved_at'])!,
    );
  }

  @override
  $NoteRevisionsTable createAlias(String alias) {
    return $NoteRevisionsTable(attachedDatabase, alias);
  }
}

class NoteRevisionRow extends DataClass implements Insertable<NoteRevisionRow> {
  final String id;
  final String noteId;
  final String title;
  final String contentMarkdown;
  final int version;
  final DateTime savedAt;
  const NoteRevisionRow(
      {required this.id,
      required this.noteId,
      required this.title,
      required this.contentMarkdown,
      required this.version,
      required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['note_id'] = Variable<String>(noteId);
    map['title'] = Variable<String>(title);
    map['content_markdown'] = Variable<String>(contentMarkdown);
    map['version'] = Variable<int>(version);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  NoteRevisionsCompanion toCompanion(bool nullToAbsent) {
    return NoteRevisionsCompanion(
      id: Value(id),
      noteId: Value(noteId),
      title: Value(title),
      contentMarkdown: Value(contentMarkdown),
      version: Value(version),
      savedAt: Value(savedAt),
    );
  }

  factory NoteRevisionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRevisionRow(
      id: serializer.fromJson<String>(json['id']),
      noteId: serializer.fromJson<String>(json['noteId']),
      title: serializer.fromJson<String>(json['title']),
      contentMarkdown: serializer.fromJson<String>(json['contentMarkdown']),
      version: serializer.fromJson<int>(json['version']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'noteId': serializer.toJson<String>(noteId),
      'title': serializer.toJson<String>(title),
      'contentMarkdown': serializer.toJson<String>(contentMarkdown),
      'version': serializer.toJson<int>(version),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  NoteRevisionRow copyWith(
          {String? id,
          String? noteId,
          String? title,
          String? contentMarkdown,
          int? version,
          DateTime? savedAt}) =>
      NoteRevisionRow(
        id: id ?? this.id,
        noteId: noteId ?? this.noteId,
        title: title ?? this.title,
        contentMarkdown: contentMarkdown ?? this.contentMarkdown,
        version: version ?? this.version,
        savedAt: savedAt ?? this.savedAt,
      );
  NoteRevisionRow copyWithCompanion(NoteRevisionsCompanion data) {
    return NoteRevisionRow(
      id: data.id.present ? data.id.value : this.id,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      title: data.title.present ? data.title.value : this.title,
      contentMarkdown: data.contentMarkdown.present
          ? data.contentMarkdown.value
          : this.contentMarkdown,
      version: data.version.present ? data.version.value : this.version,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRevisionRow(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('title: $title, ')
          ..write('contentMarkdown: $contentMarkdown, ')
          ..write('version: $version, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, noteId, title, contentMarkdown, version, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRevisionRow &&
          other.id == this.id &&
          other.noteId == this.noteId &&
          other.title == this.title &&
          other.contentMarkdown == this.contentMarkdown &&
          other.version == this.version &&
          other.savedAt == this.savedAt);
}

class NoteRevisionsCompanion extends UpdateCompanion<NoteRevisionRow> {
  final Value<String> id;
  final Value<String> noteId;
  final Value<String> title;
  final Value<String> contentMarkdown;
  final Value<int> version;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const NoteRevisionsCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.title = const Value.absent(),
    this.contentMarkdown = const Value.absent(),
    this.version = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteRevisionsCompanion.insert({
    required String id,
    required String noteId,
    required String title,
    required String contentMarkdown,
    required int version,
    required DateTime savedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        noteId = Value(noteId),
        title = Value(title),
        contentMarkdown = Value(contentMarkdown),
        version = Value(version),
        savedAt = Value(savedAt);
  static Insertable<NoteRevisionRow> custom({
    Expression<String>? id,
    Expression<String>? noteId,
    Expression<String>? title,
    Expression<String>? contentMarkdown,
    Expression<int>? version,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (title != null) 'title': title,
      if (contentMarkdown != null) 'content_markdown': contentMarkdown,
      if (version != null) 'version': version,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteRevisionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? noteId,
      Value<String>? title,
      Value<String>? contentMarkdown,
      Value<int>? version,
      Value<DateTime>? savedAt,
      Value<int>? rowid}) {
    return NoteRevisionsCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      contentMarkdown: contentMarkdown ?? this.contentMarkdown,
      version: version ?? this.version,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentMarkdown.present) {
      map['content_markdown'] = Variable<String>(contentMarkdown.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteRevisionsCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('title: $title, ')
          ..write('contentMarkdown: $contentMarkdown, ')
          ..write('version: $version, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $NoteRevisionsTable noteRevisions = $NoteRevisionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [notes, tasks, noteRevisions];
}

typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  required String id,
  Value<String> title,
  Value<String> contentMarkdown,
  Value<String> tags,
  Value<String> category,
  Value<bool> isEncrypted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> version,
  Value<String?> linkedTaskId,
  Value<String?> sketchPath,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> contentMarkdown,
  Value<String> tags,
  Value<String> category,
  Value<bool> isEncrypted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<String?> linkedTaskId,
  Value<String?> sketchPath,
  Value<int> rowid,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentMarkdown => $composableBuilder(
      column: $table.contentMarkdown,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedTaskId => $composableBuilder(
      column: $table.linkedTaskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sketchPath => $composableBuilder(
      column: $table.sketchPath, builder: (column) => ColumnFilters(column));
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentMarkdown => $composableBuilder(
      column: $table.contentMarkdown,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedTaskId => $composableBuilder(
      column: $table.linkedTaskId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sketchPath => $composableBuilder(
      column: $table.sketchPath, builder: (column) => ColumnOrderings(column));
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentMarkdown => $composableBuilder(
      column: $table.contentMarkdown, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get linkedTaskId => $composableBuilder(
      column: $table.linkedTaskId, builder: (column) => column);

  GeneratedColumn<String> get sketchPath => $composableBuilder(
      column: $table.sketchPath, builder: (column) => column);
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    NoteRow,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NoteRow, BaseReferences<_$AppDatabase, $NotesTable, NoteRow>),
    NoteRow,
    PrefetchHooks Function()> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> contentMarkdown = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isEncrypted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<String?> linkedTaskId = const Value.absent(),
            Value<String?> sketchPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion(
            id: id,
            title: title,
            contentMarkdown: contentMarkdown,
            tags: tags,
            category: category,
            isEncrypted: isEncrypted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            version: version,
            linkedTaskId: linkedTaskId,
            sketchPath: sketchPath,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> title = const Value.absent(),
            Value<String> contentMarkdown = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isEncrypted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> version = const Value.absent(),
            Value<String?> linkedTaskId = const Value.absent(),
            Value<String?> sketchPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            id: id,
            title: title,
            contentMarkdown: contentMarkdown,
            tags: tags,
            category: category,
            isEncrypted: isEncrypted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            version: version,
            linkedTaskId: linkedTaskId,
            sketchPath: sketchPath,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    NoteRow,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NoteRow, BaseReferences<_$AppDatabase, $NotesTable, NoteRow>),
    NoteRow,
    PrefetchHooks Function()>;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String title,
  required String noteId,
  required DateTime dueAt,
  Value<bool> isCompleted,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> noteId,
  Value<DateTime> dueAt,
  Value<bool> isCompleted,
  Value<int> rowid,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    TaskRow,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
    TaskRow,
    PrefetchHooks Function()> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> noteId = const Value.absent(),
            Value<DateTime> dueAt = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            title: title,
            noteId: noteId,
            dueAt: dueAt,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String noteId,
            required DateTime dueAt,
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            title: title,
            noteId: noteId,
            dueAt: dueAt,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    TaskRow,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
    TaskRow,
    PrefetchHooks Function()>;
typedef $$NoteRevisionsTableCreateCompanionBuilder = NoteRevisionsCompanion
    Function({
  required String id,
  required String noteId,
  required String title,
  required String contentMarkdown,
  required int version,
  required DateTime savedAt,
  Value<int> rowid,
});
typedef $$NoteRevisionsTableUpdateCompanionBuilder = NoteRevisionsCompanion
    Function({
  Value<String> id,
  Value<String> noteId,
  Value<String> title,
  Value<String> contentMarkdown,
  Value<int> version,
  Value<DateTime> savedAt,
  Value<int> rowid,
});

class $$NoteRevisionsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteRevisionsTable> {
  $$NoteRevisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentMarkdown => $composableBuilder(
      column: $table.contentMarkdown,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnFilters(column));
}

class $$NoteRevisionsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteRevisionsTable> {
  $$NoteRevisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentMarkdown => $composableBuilder(
      column: $table.contentMarkdown,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnOrderings(column));
}

class $$NoteRevisionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteRevisionsTable> {
  $$NoteRevisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentMarkdown => $composableBuilder(
      column: $table.contentMarkdown, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$NoteRevisionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NoteRevisionsTable,
    NoteRevisionRow,
    $$NoteRevisionsTableFilterComposer,
    $$NoteRevisionsTableOrderingComposer,
    $$NoteRevisionsTableAnnotationComposer,
    $$NoteRevisionsTableCreateCompanionBuilder,
    $$NoteRevisionsTableUpdateCompanionBuilder,
    (
      NoteRevisionRow,
      BaseReferences<_$AppDatabase, $NoteRevisionsTable, NoteRevisionRow>
    ),
    NoteRevisionRow,
    PrefetchHooks Function()> {
  $$NoteRevisionsTableTableManager(_$AppDatabase db, $NoteRevisionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteRevisionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteRevisionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteRevisionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> noteId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> contentMarkdown = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteRevisionsCompanion(
            id: id,
            noteId: noteId,
            title: title,
            contentMarkdown: contentMarkdown,
            version: version,
            savedAt: savedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String noteId,
            required String title,
            required String contentMarkdown,
            required int version,
            required DateTime savedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteRevisionsCompanion.insert(
            id: id,
            noteId: noteId,
            title: title,
            contentMarkdown: contentMarkdown,
            version: version,
            savedAt: savedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NoteRevisionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NoteRevisionsTable,
    NoteRevisionRow,
    $$NoteRevisionsTableFilterComposer,
    $$NoteRevisionsTableOrderingComposer,
    $$NoteRevisionsTableAnnotationComposer,
    $$NoteRevisionsTableCreateCompanionBuilder,
    $$NoteRevisionsTableUpdateCompanionBuilder,
    (
      NoteRevisionRow,
      BaseReferences<_$AppDatabase, $NoteRevisionsTable, NoteRevisionRow>
    ),
    NoteRevisionRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$NoteRevisionsTableTableManager get noteRevisions =>
      $$NoteRevisionsTableTableManager(_db, _db.noteRevisions);
}
