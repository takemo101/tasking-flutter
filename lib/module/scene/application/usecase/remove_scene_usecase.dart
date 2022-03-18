import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
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

  Future<AppResult<SceneID, ApplicationException>> execute(String id) async {
    return await AppResult.listen(
      () async => await _transaction.transaction(() async {
        final scene = await _repository.findByID(SceneID(id));

        if (scene == null) {
          throw NotFoundException(id);
        }

        await _repository.remove(scene.remove());

        return scene.id;
      }),
    );
  }
}
