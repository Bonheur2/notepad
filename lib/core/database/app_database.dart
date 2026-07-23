import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/notes_table.dart';
import 'tables/tasks_table.dart';
import 'tables/note_revisions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Notes, Tasks, NoteRevisions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(notes, notes.category);
          }
          if (from < 3) {
            await m.createTable(tasks);
          }
          if (from < 4) {
            await m.createTable(noteRevisions);
          }
          if (from < 5) {
            await m.addColumn(notes, notes.sketchPath);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'notepad.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}