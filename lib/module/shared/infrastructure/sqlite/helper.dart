import 'dart:io';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';

import 'package:tasking/module/shared/infrastructure/sqlite/migration/migration_20220308.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/migration/migration_20220311.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/migration/migration_20220312.dart';

const List<SQLiteMigration> _migrations = <SQLiteMigration>[
  Migration20220308(),
  Migration20220311(),
  Migration20220312(),
];

class SQLiteHelper {
  final String _databaseName;
  final int _databaseVersion;

  Database? _database;
  Transaction? _transaction;

  SQLiteHelper({
    String name = 'database.sqlite',
    int version = 1,
  })  : _databaseName = name,
        _databaseVersion = version;

  Future<Database> _connection() async {
    if (!isConnected()) {
      await open();
    }
    return _database!;
  }

  Future<DatabaseExecutor> executor() async {
    return _transaction ?? await _connection();
  }

  bool isConnected() {
    return _database != null;
  }

  Future<void> open() async {
    if (!isConnected()) {
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        // for pc
        _database = await _openDatabaseForPC();
      } else {
        // for phone
        _database = await _openDatabaseForPhone();
      }
    }
  }

  Future<void> dispose() async {
    await _database?.close();
    _database = null;
  }

  Future<T> transaction<T>(Future<T> Function() f) async {
    return (await _connection()).transaction<T>((txn) async {
      _transaction = txn;
      return await f();
    }).then((v) {
      _transaction = null;
      return v;
    });
  }

  /// create database
  FutureOr<void> _onCreate(Database db, int version) async {
    var batch = db.batch();
    for (final migration in _migrations) {
      migration.create(batch);
    }

    await batch.commit();
  }

  /// configure database
  FutureOr<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// open database for pc
  Future<Database> _openDatabaseForPC() async {
    final path = currentDatabasePath();

    sqfliteFfiInit();
    final options = OpenDatabaseOptions(
      version: _databaseVersion,
      onCreate: (Database db, int version) => _onCreate(db, version),
      onConfigure: (Database db) => _onConfigure(db),
    );

    return databaseFactoryFfi.openDatabase(path, options: options);
  }

  /// open database for phone
  Future<Database> _openDatabaseForPhone() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) => _onCreate(db, version),
      onConfigure: (Database db) => _onConfigure(db),
    );
  }

  /// current database file path
  String currentDatabasePath() {
    return join(Directory.current.path, _databaseName);
  }
}
