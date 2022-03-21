import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';
import 'package:sqflite/sqflite.dart' show Batch;

class Migration20220308 implements SQLiteMigration {
  const Migration20220308();

  @override
  void run(Batch batch) {
    // scenes table
    batch.execute('DROP TABLE IF EXISTS scenes');
    batch.execute('''
      CREATE TABLE scenes (
        id TEXT NOT NULL,
        name TEXT NOT NULL,
        genre TEXT NOT NULL,
        last_modified TEXT NOT NULL,
        PRIMARY KEY (id)
      )
    ''');
  }

  @override
  int get id => 20220308;
}
