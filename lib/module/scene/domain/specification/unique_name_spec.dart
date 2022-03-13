import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';

// unique name specification
class UniqueNameSpec {
  final SceneRepository _repository;

  UniqueNameSpec(this._repository);

  // is unique scene name
  Future<bool> isSatisfiedBy(CreatedScene scene) async {
    final list = await _repository.listByName(scene.name);
    list.remove(scene);

    return list.isEmpty;
  }
}
