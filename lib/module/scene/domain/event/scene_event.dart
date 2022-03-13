import 'package:meta/meta.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/shared/domain/event.dart';

@immutable
class CreateSceneEvent implements Event {
  final SceneID id;
  final SceneName name;
  final Genre genre;

  const CreateSceneEvent({
    required this.id,
    required this.name,
    required this.genre,
  });
}
