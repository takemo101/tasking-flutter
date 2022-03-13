import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/task/application/dto/task_data.dart';
import 'package:tasking/module/task/application/query/task_query.dart';

/// discarded task list usecase
class DiscardedTaskListUseCase {
  final TaskQuery _query;

  DiscardedTaskListUseCase({
    required TaskQuery query,
  }) : _query = query;

  Future<List<TaskData>> execute(String sceneID) async {
    return await _query.allDiscardedBySceneID(SceneID(sceneID));
  }
}
