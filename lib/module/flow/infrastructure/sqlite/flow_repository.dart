import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_repository_mapper.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:sqflite/sqflite.dart';

class FlowSQLiteRepository implements FlowRepository {
  final SQLiteHelper _helper;

  final String _table = 'scenes';
  final String _operationTable = 'operations';

  final FlowRepositoryMapper _mapper = FlowRepositoryMapper();

  FlowSQLiteRepository({required SQLiteHelper helper}) : _helper = helper;

  @override
  Future<CreatedFlow?> findByID(SceneID id) async {
    final maps = await _helper.executor().rawQuery(
      '''
        SELECT $_operationTable.*
        FROM $_table
        INNER JOIN $_operationTable
        ON $_table.id = $_operationTable.scene_id
        WHERE $_table.id = ?
      ''',
      [id.value],
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapper.fromMapToCreatedFlow(id, maps);
  }

  @override
  Future<void> store(CreatedFlow flow) async {
    final maps = _mapper.fromCreatedFlowToOperationMapList(flow);
    for (final map in maps) {
      await _helper.executor().insert(
            _operationTable,
            map,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
    }
  }

  @override
  Future<void> update(CreatedFlow flow) async {
    // all delete
    await _helper.executor().delete(
      _operationTable,
      where: "scene_id = ?",
      whereArgs: [flow.id.value],
    );

    final maps = _mapper.fromCreatedFlowToOperationMapList(flow);
    for (final map in maps) {
      await _helper.executor().insert(_operationTable, map);
    }
  }
}
