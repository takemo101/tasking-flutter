import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/task/domain/vo/task_content.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

/// abstract task event
abstract class TaskEvent implements Event {
  final TaskID id;
  final TaskContent content;
  final SceneID sceneID;
  final OperationID operationID;

  const TaskEvent({
    required this.id,
    required this.content,
    required this.sceneID,
    required this.operationID,
  });
}

/// start task event
@immutable
class StartTaskEvent extends TaskEvent {
  const StartTaskEvent({
    required TaskID id,
    required TaskContent content,
    required SceneID sceneID,
    required OperationID operationID,
  }) : super(
          id: id,
          content: content,
          sceneID: sceneID,
          operationID: operationID,
        );
//
}

/// resume task event
@immutable
class ResumeTaskEvent extends TaskEvent {
  const ResumeTaskEvent({
    required TaskID id,
    required TaskContent content,
    required SceneID sceneID,
    required OperationID operationID,
  }) : super(
          id: id,
          content: content,
          sceneID: sceneID,
          operationID: operationID,
        );
}

/// change task operation event
@immutable
class ChangeTaskOperationEvent implements Event {
  final TaskID id;
  final TaskContent content;
  final SceneID sceneID;
  final OperationID beforeOperationID;
  final OperationID afterOperationID;

  const ChangeTaskOperationEvent({
    required this.id,
    required this.content,
    required this.sceneID,
    required this.beforeOperationID,
    required this.afterOperationID,
  });
}
