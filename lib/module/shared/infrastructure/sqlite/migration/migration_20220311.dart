import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration20220311 implements SQLiteMigration {
  const Migration20220311();

  @override
  Future<void> run(Database db) async {
    final batch = db.batch();

    // operations table
    batch.execute('DROP TABLE IF EXISTS operations');
    batch.execute('''
      CREATE TABLE operations (
        id TEXT NOT NULL,
        scene_id TEXT NOT NULL,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        flow_order INTEGER NOT NULL,
        PRIMARY KEY (id),
        FOREIGN KEY (scene_id) REFERENCES scenes (id) ON DELETE CASCADE
      )
    ''');
    batch.execute('''
      CREATE INDEX idx_flow_order
      ON operations(flow_order)
    ''');

    await batch.commit();
  }

  @override
  int get id => 20220311;
}
