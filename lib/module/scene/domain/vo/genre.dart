/// genres
enum Genre {
  life,
  jobs,
  hobby,
}

/// genre string extension
extension GenreName on Genre {
  /// create from name string
  static Genre fromName(String name) {
    return Genre.values.firstWhere(
      (gen) => gen.name == name,
      orElse: () => Genre.life,
    );
  }
}
