import 'package:sqflite/sqflite.dart';

abstract class SQLiteMigration {
  /// on create migrate process
  void create(Batch batch);
}
