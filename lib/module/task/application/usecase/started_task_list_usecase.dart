import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/task/application/dto/task_data.dart';
import 'package:tasking/module/task/application/query/task_query.dart';

/// started task list usecase
class StartedTaskListUseCase {
  final TaskQuery _query;

  StartedTaskListUseCase({
    required TaskQuery query,
  }) : _query = query;

  Future<List<TaskData>> execute(String sceneID) async {
    return await _query.allStartedBySceneID(SceneID(sceneID));
  }
}
