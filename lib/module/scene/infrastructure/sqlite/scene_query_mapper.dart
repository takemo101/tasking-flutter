import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';

/// scene query mapper class
class SceneQueryMapper {
  /// from map to scene dto
  SceneData fromMapToSceneData(Map<String, dynamic> map) {
    final genre = GenreName.fromName(map['genre'].toString());
    return SceneData(
      id: map['id'].toString(),
      name: map['name'].toString(),
      genre: GenreData(
        label: genre.name,
        name: genre.jpname,
      ),
      lastModified: DateTime.parse(
        map['last_modified'].toString(),
      ),
    );
  }
}
