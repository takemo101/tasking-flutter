import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/application/query/scene_query.dart';

/// scene list usecase
class SceneListUseCase {
  final SceneQuery _query;

  SceneListUseCase({
    required SceneQuery query,
  }) : _query = query;

  Future<List<SceneData>> execute() async {
    return await _query.all();
  }
}
