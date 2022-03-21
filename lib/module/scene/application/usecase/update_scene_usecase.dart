import 'package:meta/meta.dart';
import 'package:tasking/module/scene/application/exception.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/scene/domain/specification/unique_name_spec.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

/// update scene command dto
@immutable
class UpdateSceneCommand {
  final String id;
  final String name;
  final String genre;

  const UpdateSceneCommand({
    required this.id,
    required this.name,
    required this.genre,
  });
}

/// update scene usecase
class UpdateSceneUseCase {
  final SceneRepository _repository;
  final Transaction _transaction;
  final UniqueNameSpec _spec;

  UpdateSceneUseCase({
    required SceneRepository repository,
    required Transaction transaction,
  })  : _repository = repository,
        _transaction = transaction,
        _spec = UniqueNameSpec(repository);

  Future<AppResult<SceneID, ApplicationException>> execute(
      UpdateSceneCommand command) async {
    return await AppResult.monitor(
      () async => await _transaction.transaction(() async {
        final scene = await _repository.findByID(SceneID(command.id));

        if (scene == null) {
          throw NotFoundException(command.id);
        }

        final updateScene = scene.updateContent(
          name: SceneName(command.name),
          genre: GenreName.fromName(command.genre),
        );

        // unique name check
        if (!await _spec.isSatisfiedBy(updateScene)) {
          throw NotUniqueSceneNameException();
        }

        await _repository.update(updateScene);

        return updateScene.id;
      }),
    );
  }
}
