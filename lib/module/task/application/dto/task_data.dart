import 'package:meta/meta.dart';

@immutable
class TaskData {
  final String id;
  final String content;
  final String sceneID;
  final String operationID;
  final String operationName;
  final DateTime lastModified;

  const TaskData({
    required this.id,
    required this.content,
    required this.sceneID,
    required this.operationID,
    required this.operationName,
    required this.lastModified,
  });
}
