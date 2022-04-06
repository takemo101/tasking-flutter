import 'package:meta/meta.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_type.dart';

@immutable
class SceneData {
  final String id;
  final String name;
  final GenreData genre;
  final SceneTypeData type;
  final DateTime lastModified;

  const SceneData({
    required this.id,
    required this.name,
    required this.genre,
    required this.type,
    required this.lastModified,
  });
}

@immutable
class GenreData {
  final String label;
  final String name;

  const GenreData({
    required this.label,
    required this.name,
  });

  GenreData.inital()
      : this(
          label: Genre.life.name,
          name: Genre.life.jpname,
        );

  static List<GenreData> toGenres() {
    List<GenreData> result = [];

    for (final genre in Genre.values) {
      result.add(GenreData(
        label: genre.name,
        name: genre.jpname,
      ));
    }

    return result;
  }

  @override
  bool operator ==(Object other) => other is GenreData && other.label == label;

  @override
  int get hashCode => label.hashCode;
}

@immutable
class SceneTypeData {
  final String label;
  final String name;

  const SceneTypeData({
    required this.label,
    required this.name,
  });

  SceneTypeData.inital()
      : this(
          label: SceneType.task.name,
          name: SceneType.task.jpname,
        );

  static List<SceneTypeData> toTypes() {
    List<SceneTypeData> result = [];

    for (final type in SceneType.values) {
      result.add(SceneTypeData(
        label: type.name,
        name: type.jpname,
      ));
    }

    return result;
  }

  @override
  bool operator ==(Object other) =>
      other is SceneTypeData && other.label == label;

  @override
  int get hashCode => label.hashCode;
}

/// genre string extension
extension GenreJPName on Genre {
  /// english jp name map
  static final _jpnames = {
    Genre.life: "生活",
    Genre.jobs: "仕事",
    Genre.hobby: "趣味",
  };

  /// get string jp name
  String get jpname => _jpnames[this] ?? "";
}

/// scene type string extension
extension SceneTypeJPName on SceneType {
  /// english jp name map
  static final _jpnames = {
    SceneType.task: "フロー",
    SceneType.alarm: "アラーム",
  };

  /// get string jp name
  String get jpname => _jpnames[this] ?? "";
}
