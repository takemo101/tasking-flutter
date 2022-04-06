import 'package:meta/meta.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/shared/domain/event.dart';

@immutable
class CreateTaskSceneEvent implements Event {
  final SceneID id;
  final SceneName name;
  final Genre genre;

  const CreateTaskSceneEvent({
    required this.id,
    required this.name,
    required this.genre,
  });
}

@immutable
class CreateAlarmSceneEvent implements Event {
  final SceneID id;
  final SceneName name;
  final Genre genre;

  const CreateAlarmSceneEvent({
    required this.id,
    required this.name,
    required this.genre,
  });
}
