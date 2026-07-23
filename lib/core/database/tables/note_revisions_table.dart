import 'package:drift/drift.dart';

@DataClassName('NoteRevisionRow')
class NoteRevisions extends Table {
  TextColumn get id => text()();
  TextColumn get noteId => text()();
  TextColumn get title => text()();
  TextColumn get contentMarkdown => text()();
  IntColumn get version => integer()();
  DateTimeColumn get savedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}