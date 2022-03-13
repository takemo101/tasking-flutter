import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';
import 'package:sqflite/sqflite.dart' show Batch;

class Migration20220312 implements SQLiteMigration {
  const Migration20220312();

  @override
  void create(Batch batch) {
    // tasks table
    batch.execute('DROP TABLE IF EXISTS tasks');
    batch.execute('''
      CREATE TABLE tasks (
        id TEXT NOT NULL,
        scene_id TEXT NOT NULL,
        operation_id TEXT NOT NULL,
        content TEXT NOT NULL,
        last_modified TEXT NOT NULL,
        is_discarded INTEGER NOT NULL,
        PRIMARY KEY (id),
        FOREIGN KEY (scene_id) REFERENCES scenes (id) ON DELETE CASCADE
        FOREIGN KEY (operation_id) REFERENCES operations (id) ON DELETE CASCADE
      )
    ''');
  }
}
