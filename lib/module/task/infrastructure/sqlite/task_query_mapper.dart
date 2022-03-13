import 'package:tasking/module/task/application/dto/task_data.dart';

/// task query mapper class
class TaskQueryMapper {
  /// from map to task dto
  TaskData fromMapToTaskData(Map<String, dynamic> map) {
    return TaskData(
      id: map['id'].toString(),
      content: map['content'].toString(),
      sceneID: map['scene_id'].toString(),
      operationID: map['operation_id'].toString(),
      operationName: map['operation_name'].toString(),
      lastModified: DateTime.parse(
        map['last_modified'].toString(),
      ),
    );
  }
}
