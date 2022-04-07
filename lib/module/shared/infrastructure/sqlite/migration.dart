import 'package:sqflite/sqflite.dart';
// ignore: implementation_imports
import 'package:sqflite_common/src/collection_utils.dart' show QueryResultSet;

import 'package:tasking/module/shared/infrastructure/sqlite/migration/migration_20220308.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/migration/migration_20220311.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/migration/migration_20220312.dart';

import 'package:tasking/module/shared/infrastructure/sqlite/migration/factory.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/migration/migration_20220327.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/migration/migration_20220331.dart';

abstract class SQLiteMigration {
  /// get unique id
  int get id;

  /// on create migrate process
  Future<void> run(Database db);
}

abstract class SQLiteRecordFactory {
  /// record factory process
  Future<void> factory(Database db);
}

const List<SQLiteMigration> _migrations = <SQLiteMigration>[
  Migration20220308(),
  Migration20220311(),
  Migration20220312(),
  Migration20220327(),
  Migration20220331(),
];

const SQLiteRecordFactory _factory = RecordFactory();

class Migrator {
  final String _table = 'migrations';

  final Database _db;

  Migrator(Database db) : _db = db;

  Future<void> createTable() async {
    await _db.execute('DROP TABLE IF EXISTS $_table');
    await _db.execute('''
      CREATE TABLE $_table (
        id INTEGER NOT NULL,
        PRIMARY KEY (id)
      )
    ''');
  }

  Future<void> _save(List<int> ids) async {
    for (final id in ids) {
      await _db.insert(
        _table,
        {
          'id': id,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<bool> _has(int id) async {
    final batch = _db.batch();

    batch.rawQuery(
      'SELECT COUNT(id) as count FROM $_table WHERE id = ?',
      [id],
    );

    final result = BatchCommitObject(await batch.commit());

    if (result.hasResult) {
      final count = result.result<int>('count');
      return count != null ? count > 0 : false;
    }

    return false;
  }

  Future<void> migrate() async {
    // migrated id list
    List<int> migratedIDs = [];

    // run migrations
    for (final migration in _migrations) {
      if (!await _has(migration.id)) {
        migration.run(_db);
      }

      migratedIDs.add(migration.id);
    }

    // save id list
    await _save(migratedIDs);
  }

  Future<void> factory() async {
    await _factory.factory(_db);
  }
}

class BatchCommitObject {
  final Object? _result;

  BatchCommitObject(List<Object?> result) : _result = result.last;

  bool get hasResult => _result != null;

  T? result<T extends Object>(String key) {
    if (_result != null) {
      final set = _result as QueryResultSet;
      final value = set.first[key];

      return value != null ? value as T : null;
    }

    return null;
  }
}
