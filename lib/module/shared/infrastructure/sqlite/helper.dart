import 'dart:io';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';

class SQLiteHelper {
  static SQLiteHelper? _instance;

  final String _databaseName;
  final int _databaseVersion;

  Database? _database;
  Transaction? _transaction;

  SQLiteHelper._({
    required String name,
    required int version,
  })  : _databaseName = name,
        _databaseVersion = version;

  factory SQLiteHelper({
    String name = 'database.sqlite',
    int version = 1,
  }) {
    return _instance ??= SQLiteHelper._(
      name: name,
      version: version,
    );
  }

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
    final connect = await _connection();
    return connect.transaction<T>((txn) async {
      _transaction = txn;
      return await f();
    }).then((v) {
      _transaction = null;
      return v;
    });
  }

  /// create database
  FutureOr<void> _onCreate(Database db, int version) async {
    final migrator = Migrator(db);

    // create migrations table
    await migrator.createTable();

    // run migrate
    await migrator.migrate();

    // run record factory
    await migrator.factory();
  }

  /// upgrade database
  FutureOr<void> _onUpgrade(
      Database db, int beforeVersion, int afterVersion) async {
    final migrator = Migrator(db);

    // run migrate
    await migrator.migrate();
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
      onUpgrade: (Database db, int beforeVersion, int afterVersion) =>
          _onUpgrade(
        db,
        beforeVersion,
        afterVersion,
      ),
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
      onUpgrade: (Database db, int beforeVersion, int afterVersion) =>
          _onUpgrade(
        db,
        beforeVersion,
        afterVersion,
      ),
      onConfigure: (Database db) => _onConfigure(db),
    );
  }

  /// current database file path
  String currentDatabasePath() {
    return join(Directory.current.path, _databaseName);
  }
}
