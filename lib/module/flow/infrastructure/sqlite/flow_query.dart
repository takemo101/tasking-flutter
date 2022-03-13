import 'package:tasking/module/flow/application/dto/flow_data.dart';
import 'package:tasking/module/flow/application/query/flow_query.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_query_mapper.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';

class FlowSQLiteQuery implements FlowQuery {
  final SQLiteHelper _helper;

  final String _table = 'scenes';
  final String _operationTable = 'operations';

  final FlowQueryMapper _mapper = FlowQueryMapper();

  FlowSQLiteQuery({
    required SQLiteHelper helper,
  }) : _helper = helper;

  @override
  Future<FlowData?> detail(SceneID id) async {
    final maps = await _helper.executor().rawQuery(
      '''
        SELECT $_operationTable.*
        FROM $_table
        INNER JOIN $_operationTable
        ON $_table.id = $_operationTable.scene_id
        WHERE $_table.id = ?
        ORDER BY flow_order ASC
      ''',
      [id.value],
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapper.fromMapToFlowData(id, maps);
  }
}
