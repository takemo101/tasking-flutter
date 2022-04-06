import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/task/domain/task_repository.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';
import 'package:tasking/module/task/infrastructure/sqlite/task_repository_mapper.dart';
import 'package:sqflite/sqflite.dart';

class TaskSQLiteRepository implements TaskRepository {
  final SQLiteHelper _helper;

  final String _table = 'tasks';

  final TaskRepositoryMapper _mapper = TaskRepositoryMapper();

  TaskSQLiteRepository({required SQLiteHelper helper}) : _helper = helper;

  @override
  Future<bool> existsByOperationID(OperationID id) async {
    final executor = await _helper.executor();
    final list = await executor.query(
      _table,
      where: 'operation_id = ?',
      whereArgs: [id.value],
      limit: 1,
    );

    return list.isNotEmpty;
  }

  @override
  Future<StartedTask?> findStartedByID(TaskID id) async {
    final executor = await _helper.executor();
    final list = await executor.query(
      _table,
      where: 'id = ? AND is_discarded = ?',
      whereArgs: [id.value, 0],
    );

    return list.isEmpty ? null : _mapper.fromMapToStartedTask(list.first);
  }

  @override
  Future<DiscardedTask?> findDiscardedByID(TaskID id) async {
    final executor = await _helper.executor();
    final list = await executor.query(
      _table,
      where: 'id = ? AND is_discarded = ?',
      whereArgs: [id.value, 1],
    );

    return list.isEmpty ? null : _mapper.fromMapToDiscardedTask(list.first);
  }

  @override
  Future<void> remove(RemovedTask task) async {
    final executor = await _helper.executor();
    await executor.delete(
      _table,
      where: "id = ?",
      whereArgs: [task.id.value],
    );
  }

  @override
  Future<void> store(CreatedTask task) async {
    final executor = await _helper.executor();

    await executor.insert(
      _table,
      _mapper.fromCreatedTaskToMap(task),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(CreatedTask task) async {
    final executor = await _helper.executor();
    await executor.update(
      _table,
      _mapper.fromCreatedTaskToMap(task),
      where: "id = ?",
      whereArgs: [task.id.value],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
