import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

/// remove scene usecase
class RemoveSceneUseCase {
  final SceneRepository _repository;
  final Transaction _transaction;

  RemoveSceneUseCase({
    required SceneRepository repository,
    required Transaction transaction,
  })  : _repository = repository,
        _transaction = transaction;

  Future<void> execute(String id) async {
    _transaction.transaction(() async {
      final scene = await _repository.findByID(SceneID(id));

      if (scene == null) {
        throw NotFoundException(id, name: 'scene');
      }

      await _repository.remove(scene.remove());
    });
  }
}
