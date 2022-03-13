/// genres
enum Genre {
  life,
  jobs,
  hobby,
}

/// genre string extension
extension GenreName on Genre {
  /// english name map
  static final _names = {
    Genre.life: "life",
    Genre.jobs: "jobs",
    Genre.hobby: "hobby",
  };

  /// get string name
  String get name => _names[this] ?? "";

  /// create from name string
  static Genre fromName(String name) {
    Genre genre = Genre.life;

    _names.forEach((key, value) {
      if (name == value) {
        genre = key;
      }
    });

    return genre;
  }
}
