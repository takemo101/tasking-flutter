import 'package:meta/meta.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';

@immutable
class SceneData {
  final String id;
  final String name;
  final String genre;
  final String genreJPName;
  final DateTime lastModified;

  const SceneData({
    required this.id,
    required this.name,
    required this.genre,
    required this.genreJPName,
    required this.lastModified,
  });
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
