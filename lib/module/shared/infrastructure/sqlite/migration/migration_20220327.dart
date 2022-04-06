import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';
import 'package:sqflite/sqflite.dart' show Batch;

class Migration20220327 implements SQLiteMigration {
  const Migration20220327();

  @override
  void run(Batch batch) {
    // tasks table
    batch.execute('''
      ALTER TABLE scenes ADD COLUMN type TEXT NOT NULL DEFAULT 'task'
    ''');
  }

  @override
  int get id => 20220327;
}
