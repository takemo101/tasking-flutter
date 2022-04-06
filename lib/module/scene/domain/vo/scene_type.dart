/// scene types
enum SceneType {
  task,
  alarm,
}

/// scene type string extension
extension SceneTypeName on SceneType {
  /// create from name string
  static SceneType fromName(String name) {
    return SceneType.values.firstWhere(
      (typ) => typ.name == name,
      orElse: () => SceneType.task,
    );
  }
}
