import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/application/query/scene_query.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_query_mapper.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';

class SceneSQLiteQuery implements SceneQuery {
  final SQLiteHelper _helper;

  final String _table = 'scenes';

  final SceneQueryMapper _mapper = SceneQueryMapper();

  SceneSQLiteQuery({
    required SQLiteHelper helper,
  }) : _helper = helper;

  @override
  Future<List<SceneData>> all() async {
    final executor = await _helper.executor();
    final list = await executor.query(
      _table,
      orderBy: 'last_modified DESC',
    );

    if (list.isEmpty) {
      return <SceneData>[];
    }

    return list.map((data) => _mapper.fromMapToSceneData(data)).toList();
  }
}
