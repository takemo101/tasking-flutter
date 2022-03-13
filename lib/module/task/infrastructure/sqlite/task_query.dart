import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/task/application/dto/task_data.dart';
import 'package:tasking/module/task/application/query/task_query.dart';
import 'package:tasking/module/task/infrastructure/sqlite/task_query_mapper.dart';

class TaskSQLiteQuery implements TaskQuery {
  final SQLiteHelper _helper;

  final String _table = 'tasks';

  final String _operationTable = 'operations';

  final TaskQueryMapper _mapper = TaskQueryMapper();

  TaskSQLiteQuery({
    required SQLiteHelper helper,
  }) : _helper = helper;

  String get _selectSQL => '''
        SELECT $_table.*, $_operationTable.name AS operation_name
        FROM $_table
        INNER JOIN $_operationTable
        ON $_table.operation_id = $_operationTable.id
        WHERE $_table.scene_id = ? AND $_table.is_discarded = ?
        ORDER BY flow_order ASC
      ''';

  @override
  Future<List<TaskData>> allDiscardedBySceneID(SceneID sceneID) async {
    final maps = await _helper.executor().rawQuery(
      _selectSQL,
      [sceneID.value, 1],
    );

    if (maps.isEmpty) {
      return <TaskData>[];
    }

    return maps.map((data) => _mapper.fromMapToTaskData(data)).toList();
  }

  @override
  Future<List<TaskData>> allStartedBySceneID(SceneID sceneID) async {
    final maps = await _helper.executor().rawQuery(
      _selectSQL,
      [sceneID.value, 0],
    );

    if (maps.isEmpty) {
      return <TaskData>[];
    }

    return maps.map((data) => _mapper.fromMapToTaskData(data)).toList();
  }
}
