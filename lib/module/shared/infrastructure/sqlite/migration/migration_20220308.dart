import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration20220308 implements SQLiteMigration {
  const Migration20220308();

  @override
  Future<void> run(Database db) async {
    final batch = db.batch();

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

    await batch.commit();
  }

  @override
  int get id => 20220308;
}
