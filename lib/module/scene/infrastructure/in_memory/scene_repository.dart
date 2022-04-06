import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';

class SceneInMemoryRepository implements SceneRepository {
  final List<CreatedScene> _scenes = <CreatedScene>[];

  @override
  Future<CreatedScene?> findByID(SceneID id) async {
    CreatedScene? scene = _scenes.cast<CreatedScene?>().firstWhere(
        (scene) => scene != null && scene.id == id,
        orElse: () => null);

    return scene == null
        ? null
        : CreatedScene.reconstruct(
            id: scene.id,
            name: scene.name,
            genre: scene.genre,
            type: scene.type,
            lastModified: scene.lastModified,
          );
  }

  @override
  Future<List<CreatedScene>> listByName(SceneName name) async {
    return _scenes.where((scene) => scene.name == name).toList();
  }

  @override
  Future<void> remove(RemovedScene scene) async {
    _scenes.remove(scene);
  }

  @override
  Future<void> store(CreatedScene scene) async {
    _scenes.add(CreatedScene.reconstruct(
      id: scene.id,
      name: scene.name,
      genre: scene.genre,
      type: scene.type,
      lastModified: scene.lastModified,
    ));
  }

  @override
  Future<void> update(CreatedScene scene) async {
    final target = await findByID(scene.id);
    if (target != null) {
      remove(target.remove());
      _scenes.add(CreatedScene.reconstruct(
        id: scene.id,
        name: scene.name,
        genre: scene.genre,
        type: scene.type,
        lastModified: scene.lastModified,
      ));
    }
  }
}
