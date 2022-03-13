import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/task/application/dto/task_data.dart';

/// task query service interface
abstract class TaskQuery {
  Future<List<TaskData>> allStartedBySceneID(SceneID sceneID);
  Future<List<TaskData>> allDiscardedBySceneID(SceneID sceneID);
}
