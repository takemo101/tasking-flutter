import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration20220312 implements SQLiteMigration {
  const Migration20220312();

  @override
  Future<void> run(Database db) async {
    final batch = db.batch();

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
      )
    ''');
    batch.execute('''
      CREATE INDEX idx_task_operation_d
      ON tasks(operation_id)
    ''');

    // pins table
    batch.execute('DROP TABLE IF EXISTS pins');
    batch.execute('''
      CREATE TABLE pins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scene_id TEXT NOT NULL,
        task_id TEXT NOT NULL,
        board_order INTEGER NOT NULL,
        FOREIGN KEY (scene_id) REFERENCES scenes (id) ON DELETE CASCADE
        FOREIGN KEY (task_id) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');

    await batch.commit();
  }

  @override
  int get id => 20220312;
}
