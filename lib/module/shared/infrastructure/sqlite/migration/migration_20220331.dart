import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';
import 'package:sqflite/sqflite.dart' show Batch;

class Migration20220331 implements SQLiteMigration {
  const Migration20220331();

  @override
  void run(Batch batch) {
    // alarms table
    batch.execute('DROP TABLE IF EXISTS alarms');
    batch.execute('''
      CREATE TABLE alarms (
        id TEXT NOT NULL,
        scene_id TEXT NOT NULL,
        content TEXT NOT NULL,
        last_modified TEXT NOT NULL,
        is_discarded INTEGER NOT NULL,
        PRIMARY KEY (id),
        FOREIGN KEY (scene_id) REFERENCES scenes (id) ON DELETE CASCADE
      )
    ''');

    // alarm_times table
    batch.execute('DROP TABLE IF EXISTS alarm_times');
    batch.execute('''
      CREATE TABLE alarm_times (
        id TEXT NOT NULL,
        alarm_id TEXT NOT NULL,
        hour INTEGER NOT NULL,
        minute INTEGER NOT NULL,
        is_active INTEGER NOT NULL,
        PRIMARY KEY (id),
        FOREIGN KEY (alarm_id) REFERENCES alarms (id) ON DELETE CASCADE
      )
    ''');

    // alarm_day_of_weeks table
    batch.execute('DROP TABLE IF EXISTS alarm_day_of_weeks');
    batch.execute('''
      CREATE TABLE alarm_day_of_weeks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alarm_time_id TEXT NOT NULL,
        day_of_week INTEGER NOT NULL,
        FOREIGN KEY (alarm_time_id) REFERENCES alarm_times (id) ON DELETE CASCADE
      )
    ''');
  }

  @override
  int get id => 20220331;
}
