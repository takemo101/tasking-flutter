import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_type.dart';

/// scene query mapper class
class SceneQueryMapper {
  /// from map to scene dto
  SceneData fromMapToSceneData(Map<String, dynamic> map) {
    final genre = GenreName.fromName(map['genre'].toString());
    final type = SceneTypeName.fromName(map['type'].toString());

    return SceneData(
      id: map['id'].toString(),
      name: map['name'].toString(),
      genre: GenreData(
        label: genre.name,
        name: genre.jpname,
      ),
      type: SceneTypeData(
        label: type.name,
        name: type.jpname,
      ),
      lastModified: DateTime.parse(
        map['last_modified'].toString(),
      ),
    );
  }
}
