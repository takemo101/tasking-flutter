import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/task/application/dto/task_data.dart';
import 'package:tasking/module/task/application/query/task_query.dart';
import 'package:tasking/module/task/infrastructure/sqlite/task_query_mapper.dart';

class TaskSQLiteQuery implements TaskQuery {
  final SQLiteHelper _helper;

  final String _table = 'tasks';

  final String _operationTable = 'operations';

  final String _pinTable = 'pins';

  final TaskQueryMapper _mapper = TaskQueryMapper();

  TaskSQLiteQuery({
    required SQLiteHelper helper,
  }) : _helper = helper;

  @override
  Future<List<TaskData>> allDiscardedBySceneID(SceneID sceneID) async {
    final executor = await _helper.executor();
    final maps = await executor.rawQuery(
      '''
        SELECT $_table.*, $_operationTable.name AS operation_name
        FROM $_table
        INNER JOIN $_operationTable
        ON $_table.operation_id = $_operationTable.id
        WHERE $_table.scene_id = ? AND $_table.is_discarded = ?
        ORDER BY last_modified DESC
      ''',
      [sceneID.value, 1],
    );

    if (maps.isEmpty) {
      return <TaskData>[];
    }

    return maps.map((data) => _mapper.fromMapToTaskData(data)).toList();
  }

  @override
  Future<List<TaskData>> allStartedBySceneID(SceneID sceneID) async {
    final executor = await _helper.executor();
    final maps = await executor.rawQuery(
      '''
        SELECT $_table.*, $_operationTable.name AS operation_name
        FROM $_table
        INNER JOIN $_operationTable
        ON $_table.operation_id = $_operationTable.id
        INNER JOIN $_pinTable
        ON $_table.id = $_pinTable.task_id
        WHERE $_table.scene_id = ? AND $_table.is_discarded = ?
        ORDER BY $_pinTable.board_order ASC
      ''',
      [sceneID.value, 0],
    );

    if (maps.isEmpty) {
      return <TaskData>[];
    }

    return maps.map((data) => _mapper.fromMapToTaskData(data)).toList();
  }
}
