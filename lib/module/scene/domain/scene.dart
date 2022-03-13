import 'package:meta/meta.dart';
import 'package:tasking/module/scene/domain/event/scene_event.dart';

import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/domain/vo/scene_last_modified.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
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
}

/// aggregate root base class
abstract class SceneContent extends Scene {
  final SceneName name;
  final Genre genre;
  final SceneLastModified lastModified;

  /// private constructor
  const SceneContent({
    required SceneID id,
    required this.name,
    required this.genre,
    required this.lastModified,
    List<Event> events = const <Event>[],
  }) : super(
          id: id,
          events: events,
        );

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
    required SceneLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super(
          id: id,
          name: name,
          genre: genre,
          lastModified: lastModified,
          events: events,
        );

  /// create constructor
  CreatedScene.create({
    required SceneID id,
    required SceneName name,
    required Genre genre,
  }) : super(
          id: id,
          name: name,
          genre: genre,
          lastModified: SceneLastModified.now(),
          events: <Event>[
            CreateSceneEvent(
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
    required SceneLastModified lastModified,
  }) : this._(
          id: id,
          name: name,
          genre: genre,
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
    required SceneLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super(
          id: id,
          name: name,
          genre: genre,
          lastModified: lastModified,
          events: events,
        );
}
