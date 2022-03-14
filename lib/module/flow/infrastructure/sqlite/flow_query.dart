import 'package:tasking/module/flow/application/dto/flow_data.dart';
import 'package:tasking/module/flow/application/query/flow_query.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_query_mapper.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';

class FlowSQLiteQuery implements FlowQuery {
  final SQLiteHelper _helper;

  final String _table = 'operations';

  final FlowQueryMapper _mapper = FlowQueryMapper();

  FlowSQLiteQuery({
    required SQLiteHelper helper,
  }) : _helper = helper;

  @override
  Future<FlowData?> detail(SceneID id) async {
    final executor = await _helper.executor();
    final maps = await executor.query(
      _table,
      where: 'scene_id = ?',
      whereArgs: [id.value],
      orderBy: 'flow_order ASC',
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapper.fromMapToFlowData(id, maps);
  }
}
