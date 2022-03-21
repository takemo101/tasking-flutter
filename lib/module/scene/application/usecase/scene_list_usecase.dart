import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/application/query/scene_query.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';

/// scene list usecase
class SceneListUseCase {
  final SceneQuery _query;

  SceneListUseCase({
    required SceneQuery query,
  }) : _query = query;

  Future<AppResult<List<SceneData>, ApplicationException>> execute() async {
    return await AppResult.monitor(() async => await _query.all());
  }
}
