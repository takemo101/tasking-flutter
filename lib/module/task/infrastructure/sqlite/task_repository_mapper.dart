import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/utility.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/vo/task_content.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';
import 'package:tasking/module/task/domain/vo/task_last_modified.dart';

/// task repository mapper class
class TaskRepositoryMapper {
  /// from created task to map
  Map<String, dynamic> fromCreatedTaskToMap(CreatedTask task) {
    return {
      'id': task.id.value,
      'content': task.content.value,
      'scene_id': task.sceneID.value,
      'operation_id': task.operationID.value,
      'last_modified': task.lastModified.toString(),
      'is_discarded': fromBoolToInt(task.isDiscarded),
    };
  }

  /// from map to started task aggregate
  StartedTask fromMapToStartedTask(Map<String, dynamic> map) {
    return StartedTask.reconstruct(
      id: TaskID(map['id'].toString()),
      content: TaskContent(map['content'].toString()),
      sceneID: SceneID(map['scene_id'].toString()),
      operationID: OperationID(map['operation_id'].toString()),
      lastModified:
          TaskLastModified.fromString(map['last_modified'].toString()),
    );
  }

  /// from map to discarded task aggregate
  DiscardedTask fromMapToDiscardedTask(Map<String, dynamic> map) {
    return DiscardedTask.reconstruct(
      id: TaskID(map['id'].toString()),
      content: TaskContent(map['content'].toString()),
      sceneID: SceneID(map['scene_id'].toString()),
      operationID: OperationID(map['operation_id'].toString()),
      lastModified:
          TaskLastModified.fromString(map['last_modified'].toString()),
    );
  }
}
