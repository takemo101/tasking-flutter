import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';

class SQLiteTransaction implements Transaction {
  final SQLiteHelper _helper;
  const SQLiteTransaction({required SQLiteHelper helper}) : _helper = helper;

  @override
  Future<T> transaction<T>(Future<T> Function() f) async {
    return await _helper.transaction<T>(() async => await f());
  }
}
