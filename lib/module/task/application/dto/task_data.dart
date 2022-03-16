import 'package:meta/meta.dart';

@immutable
class TaskData {
  final String id;
  final String content;
  final String sceneID;
  final TaskOperationData operation;
  final DateTime lastModified;

  const TaskData({
    required this.id,
    required this.content,
    required this.sceneID,
    required this.operation,
    required this.lastModified,
  });
}

@immutable
class TaskOperationData {
  final String id;
  final String name;
  final int color;
  const TaskOperationData({
    required this.id,
    required this.name,
    required this.color,
  });
}
