import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/domain/aggregate_root.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/task/domain/event/task_event.dart';
import 'package:tasking/module/task/domain/vo/task_content.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';
import 'package:tasking/module/task/domain/vo/task_last_modified.dart';

/// aggregate root base class
abstract class Task extends AggregateRoot {
  final TaskID id;
  final TaskContent content;
  final SceneID sceneID;
  final OperationID operationID;
  final TaskLastModified lastModified;

  /// private constructor
  const Task._({
    required this.id,
    required this.content,
    required this.sceneID,
    required this.operationID,
    required this.lastModified,
    List<Event> events = const <Event>[],
  }) : super(events);

  /// is discarded
  bool get isDiscarded => false;

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is Task && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}

/// created task class
abstract class CreatedTask extends Task {
  /// private constructor
  const CreatedTask._({
    required TaskID id,
    required TaskContent content,
    required SceneID sceneID,
    required OperationID operationID,
    required TaskLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super._(
          id: id,
          content: content,
          sceneID: sceneID,
          operationID: operationID,
          lastModified: lastModified,
          events: events,
        );
}

/// started task class
@immutable
class StartedTask extends CreatedTask {
  /// private constructor
  const StartedTask._({
    required TaskID id,
    required TaskContent content,
    required SceneID sceneID,
    required OperationID operationID,
    required TaskLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super._(
          id: id,
          content: content,
          sceneID: sceneID,
          operationID: operationID,
          lastModified: lastModified,
          events: events,
        );

  /// start task constructor
  StartedTask.start({
    required TaskID id,
    required TaskContent content,
    required Scene scene,
    required OperationID operationID,
  }) : super._(
          id: id,
          content: content,
          sceneID: scene.id,
          operationID: operationID,
          lastModified: TaskLastModified.now(),
          events: [
            StartTaskEvent(
              id: id,
              content: content,
              sceneID: scene.id,
              operationID: operationID,
            )
          ],
        ) {
    if (!scene.isTaskType) {
      throw DomainException(
        type: DomainExceptionType.specification,
        detail: "can't start the task due to the specifications!",
      );
    }
  }

  /// reconstruct
  const StartedTask.reconstruct({
    required TaskID id,
    required TaskContent content,
    required SceneID sceneID,
    required OperationID operationID,
    required TaskLastModified lastModified,
  }) : super._(
          id: id,
          content: content,
          sceneID: sceneID,
          operationID: operationID,
          lastModified: lastModified,
        );

  /// change operation
  StartedTask changeOperation(OperationID operationID) {
    return StartedTask._(
      id: id,
      content: content,
      sceneID: sceneID,
      operationID: operationID,
      lastModified: TaskLastModified.now(),
      events: recordedDomainEvent(ChangeTaskOperationEvent(
        id: id,
        content: content,
        sceneID: sceneID,
        beforeOperationID: this.operationID,
        afterOperationID: operationID,
      )),
    );
  }

  /// discard task
  DiscardedTask discard() {
    return DiscardedTask._(
      id: id,
      content: content,
      sceneID: sceneID,
      operationID: operationID,
      lastModified: TaskLastModified.now(),
      events: domainEvents,
    );
  }
}

/// discarded task class
@immutable
class DiscardedTask extends CreatedTask {
  const DiscardedTask._({
    required TaskID id,
    required TaskContent content,
    required SceneID sceneID,
    required OperationID operationID,
    required TaskLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super._(
          id: id,
          content: content,
          sceneID: sceneID,
          operationID: operationID,
          lastModified: lastModified,
          events: events,
        );

  /// reconstruct
  const DiscardedTask.reconstruct({
    required TaskID id,
    required TaskContent content,
    required SceneID sceneID,
    required OperationID operationID,
    required TaskLastModified lastModified,
  }) : super._(
          id: id,
          content: content,
          sceneID: sceneID,
          operationID: operationID,
          lastModified: lastModified,
        );

  /// resume task
  StartedTask resume() {
    return StartedTask._(
      id: id,
      content: content,
      sceneID: sceneID,
      operationID: operationID,
      lastModified: TaskLastModified.now(),
      events: recordedDomainEvent(ResumeTaskEvent(
        id: id,
        content: content,
        sceneID: sceneID,
        operationID: operationID,
      )),
    );
  }

  RemovedTask remove() {
    return RemovedTask._(
      id: id,
      content: content,
      sceneID: sceneID,
      operationID: operationID,
      lastModified: lastModified,
      events: domainEvents,
    );
  }

  /// is discarded
  @override
  bool get isDiscarded => true;
}

/// removed task class
@immutable
class RemovedTask extends Task {
  const RemovedTask._({
    required TaskID id,
    required TaskContent content,
    required SceneID sceneID,
    required OperationID operationID,
    required TaskLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super._(
          id: id,
          content: content,
          sceneID: sceneID,
          operationID: operationID,
          lastModified: lastModified,
          events: events,
        );

  /// is discarded
  @override
  bool get isDiscarded => true;
}
