import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration20220327 implements SQLiteMigration {
  const Migration20220327();

  @override
  Future<void> run(Database db) async {
    // add column
    await db.execute('''
      ALTER TABLE scenes ADD COLUMN type TEXT NOT NULL DEFAULT 'task'
    ''');
  }

  @override
  int get id => 20220327;
}
