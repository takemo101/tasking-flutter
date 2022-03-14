import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_repository_mapper.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:sqflite/sqflite.dart';

class FlowSQLiteRepository implements FlowRepository {
  final SQLiteHelper _helper;

  final String _table = 'operations';

  final FlowRepositoryMapper _mapper = FlowRepositoryMapper();

  FlowSQLiteRepository({required SQLiteHelper helper}) : _helper = helper;

  @override
  Future<Flow?> findByID(SceneID id) async {
    final executor = await _helper.executor();
    final maps = await executor.query(
      _table,
      where: "scene_id = ?",
      whereArgs: [id.value],
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapper.fromMapToFlow(id, maps);
  }

  @override
  Future<void> save(Flow flow) async {
    // all delete
    final executor = await _helper.executor();
    await executor.delete(
      _table,
      where: "scene_id = ?",
      whereArgs: [flow.id.value],
    );

    final maps = _mapper.fromFlowToOperationMapList(flow);
    for (final map in maps) {
      await executor.insert(
        _table,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
