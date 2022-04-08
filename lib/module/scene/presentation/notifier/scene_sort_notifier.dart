import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SceneSort {
  all,
  task,
  alarm,
}

/// create from name string
extension SceneSortName on SceneSort {
  static final _jpnames = {
    SceneSort.all: "全て",
    SceneSort.task: "フロー",
    SceneSort.alarm: "アラーム",
  };

  /// get string jp name
  String get jpname => _jpnames[this] ?? "";

  static SceneSort fromName(String name) {
    return SceneSort.values.firstWhere(
      (sort) => sort.name == name,
      orElse: () => SceneSort.all,
    );
  }
}

class SceneSortStateNotifier extends StateNotifier<SceneSort> {
  /// constructor
  SceneSortStateNotifier() : super(SceneSort.all);

  void change(SceneSort sort) {
    state = sort;
  }
}
