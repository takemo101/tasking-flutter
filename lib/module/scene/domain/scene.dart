import 'package:meta/meta.dart';
import 'package:tasking/module/scene/domain/event/scene_event.dart';

import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/domain/vo/scene_last_modified.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_type.dart';
import 'package:tasking/module/shared/domain/aggregate_root.dart';
import 'package:tasking/module/shared/domain/event.dart';

/// aggregate root base class
abstract class Scene extends AggregateRoot {
  final SceneID id;

  /// private constructor
  const Scene({
    required this.id,
    List<Event> events = const <Event>[],
  }) : super(events);

  SceneType get type;

  bool get isTaskType => type == SceneType.task;

  bool get isAlarmType => type == SceneType.alarm;
}

/// task type scene aggregate root base class
abstract class TaskTypeScene extends Scene {
  /// private constructor
  const TaskTypeScene({
    required SceneID id,
    List<Event> events = const <Event>[],
  }) : super(id: id, events: events);

  @override
  SceneType get type => SceneType.task;
}

/// alarm type scene aggregate root base class
abstract class AlarmTypeScene extends Scene {
  /// private constructor
  const AlarmTypeScene({
    required SceneID id,
    List<Event> events = const <Event>[],
  }) : super(id: id, events: events);

  @override
  SceneType get type => SceneType.alarm;
}

/// aggregate root base class
abstract class SceneContent extends Scene {
  final SceneName name;
  final Genre genre;
  final SceneType _type;
  final SceneLastModified lastModified;

  /// private constructor
  const SceneContent({
    required SceneID id,
    required this.name,
    required this.genre,
    required SceneType type,
    required this.lastModified,
    List<Event> events = const <Event>[],
  })  : _type = type,
        super(
          id: id,
          events: events,
        );

  @override
  SceneType get type => _type;

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is Scene && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}

/// created scene class
@immutable
class CreatedScene extends SceneContent {
  /// private constructor
  const CreatedScene._({
    required SceneID id,
    required SceneName name,
    required Genre genre,
    required SceneType type,
    required SceneLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super(
          id: id,
          name: name,
          genre: genre,
          type: type,
          lastModified: lastModified,
          events: events,
        );

  /// create constructor
  CreatedScene.create({
    required SceneID id,
    required SceneName name,
    required Genre genre,
    SceneType type = SceneType.task,
  }) : super(
          id: id,
          name: name,
          genre: genre,
          type: type,
          lastModified: SceneLastModified.now(),
          events: <Event>[
            type == SceneType.task
                ? CreateTaskSceneEvent(
                    id: id,
                    name: name,
                    genre: genre,
                  )
                : CreateAlarmSceneEvent(
                    id: id,
                    name: name,
                    genre: genre,
                  ),
          ],
        );

  /// reconstruct
  const CreatedScene.reconstruct({
    required SceneID id,
    required SceneName name,
    required Genre genre,
    required SceneType type,
    required SceneLastModified lastModified,
  }) : this._(
          id: id,
          name: name,
          genre: genre,
          type: type,
          lastModified: lastModified,
        );

  /// update scene name and genre id
  CreatedScene updateContent({
    required SceneName name,
    required Genre genre,
  }) {
    return CreatedScene._(
      id: id,
      name: name,
      genre: genre,
      type: type,
      lastModified: SceneLastModified.now(),
      events: domainEvents,
    );
  }

  /// update scene name and genre id
  CreatedScene updateActivity() {
    return CreatedScene._(
      id: id,
      name: name,
      genre: genre,
      type: type,
      lastModified: SceneLastModified.now(),
      events: domainEvents,
    );
  }

  /// remove
  RemovedScene remove() {
    return RemovedScene._(
      id: id,
      name: name,
      genre: genre,
      type: type,
      lastModified: lastModified,
      events: domainEvents,
    );
  }
}

/// removed scene class
@immutable
class RemovedScene extends SceneContent {
  /// private constructor
  const RemovedScene._({
    required SceneID id,
    required SceneName name,
    required Genre genre,
    required SceneType type,
    required SceneLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super(
          id: id,
          name: name,
          genre: genre,
          type: type,
          lastModified: lastModified,
          events: events,
        );
}
