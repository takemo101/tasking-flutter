import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository_mapper.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:sqflite/sqflite.dart';

class SceneSQLiteRepository implements SceneRepository {
  final SQLiteHelper _helper;

  final String _table = 'scenes';

  final SceneRepositoryMapper _mapper = SceneRepositoryMapper();

  SceneSQLiteRepository({
    required SQLiteHelper helper,
  }) : _helper = helper;

  @override
  Future<CreatedScene?> findByID(SceneID id) async {
    final executor = await _helper.executor();
    final list = await executor.query(
      _table,
      where: 'id = ?',
      whereArgs: [id.value],
    );

    return list.isEmpty ? null : _mapper.fromMapToCreatedScene(list[0]);
  }

  @override
  Future<List<CreatedScene>> listByName(SceneName name) async {
    final executor = await _helper.executor();
    final list = await executor.query(
      _table,
      where: 'name = ?',
      whereArgs: [name.value],
    );

    if (list.isEmpty) {
      return <CreatedScene>[];
    }

    return list.map((data) => _mapper.fromMapToCreatedScene(data)).toList();
  }

  @override
  Future<void> remove(RemovedScene scene) async {
    final executor = await _helper.executor();
    await executor.delete(
      _table,
      where: "id = ?",
      whereArgs: [scene.id.value],
    );
  }

  @override
  Future<void> store(CreatedScene scene) async {
    final executor = await _helper.executor();
    await executor.insert(
      _table,
      _mapper.fromCreatedSceneToMap(scene),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(CreatedScene scene) async {
    final executor = await _helper.executor();
    await executor.update(
      _table,
      _mapper.fromCreatedSceneToMap(scene),
      where: "id = ?",
      whereArgs: [scene.id.value],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
