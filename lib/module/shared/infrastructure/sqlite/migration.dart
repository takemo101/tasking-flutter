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
  void run(Batch batch);
}

abstract class SQLiteRecordFactory {
  /// record factory process
  void factory(Batch batch);
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

  final Batch _batch;

  Migrator(Batch batch) : _batch = batch;

  Future<void> createTable() async {
    _batch.execute('DROP TABLE IF EXISTS $_table');
    _batch.execute('''
      CREATE TABLE $_table (
        id INTEGER NOT NULL,
        PRIMARY KEY (id)
      )
    ''');

    await _batch.commit();
  }

  Future<void> _save(List<int> ids) async {
    for (final id in ids) {
      _batch.insert(
        _table,
        {
          'id': id,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await _batch.commit();
  }

  Future<bool> _has(int id) async {
    _batch.rawQuery(
      'SELECT COUNT(id) as count FROM $_table WHERE id = ?',
      [id],
    );

    final result = BatchCommitObject(await _batch.commit());

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
        migration.run(_batch);
        await _batch.commit();
      }

      migratedIDs.add(migration.id);
    }

    // save id list
    await _save(migratedIDs);
  }

  Future<void> factory() async {
    _factory.factory(_batch);
    await _batch.commit();
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
