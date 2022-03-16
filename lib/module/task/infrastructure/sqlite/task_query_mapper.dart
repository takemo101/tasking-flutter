import 'package:tasking/module/task/application/dto/task_data.dart';

/// task query mapper class
class TaskQueryMapper {
  /// from map to task dto
  TaskData fromMapToTaskData(Map<String, dynamic> map) {
    return TaskData(
      id: map['id'].toString(),
      content: map['content'].toString(),
      sceneID: map['scene_id'].toString(),
      operation: TaskOperationData(
        id: map['operation_id'].toString(),
        name: map['operation_name'].toString(),
        color: map['operation_color'],
      ),
      lastModified: DateTime.parse(
        map['last_modified'].toString(),
      ),
    );
  }
}
