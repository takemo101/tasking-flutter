import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';

/// scene repository interface
abstract class SceneRepository {
  Future<CreatedScene?> findByID(SceneID id);
  Future<List<CreatedScene>> listByName(SceneName name);
  Future<void> store(CreatedScene scene);
  Future<void> update(CreatedScene scene);
  Future<void> remove(RemovedScene scene);
}
