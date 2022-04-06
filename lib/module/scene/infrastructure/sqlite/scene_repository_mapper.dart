import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_last_modified.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/domain/vo/scene_type.dart';

/// scene repository mapper class
class SceneRepositoryMapper {
  /// from created scene to map
  Map<String, dynamic> fromCreatedSceneToMap(CreatedScene scene) {
    return {
      'id': scene.id.value,
      'name': scene.name.value,
      'genre': scene.genre.name,
      'type': scene.type.name,
      'last_modified': scene.lastModified.toString(),
    };
  }

  /// from map to created scene aggregate
  CreatedScene fromMapToCreatedScene(Map<String, dynamic> map) {
    return CreatedScene.reconstruct(
      id: SceneID(map['id'].toString()),
      name: SceneName(map['name'].toString()),
      genre: GenreName.fromName(map['genre'].toString()),
      type: SceneTypeName.fromName(map['type'].toString()),
      lastModified: SceneLastModified.fromString(
        map['last_modified'].toString(),
      ),
    );
  }
}
