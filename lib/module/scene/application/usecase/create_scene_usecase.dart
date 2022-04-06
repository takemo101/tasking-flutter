import 'package:meta/meta.dart';
import 'package:tasking/module/scene/application/exception.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/scene/domain/specification/unique_name_spec.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/domain/vo/scene_type.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

/// create scene command dto
@immutable
class CreateSceneCommand {
  final String name;
  final String genre;
  final String type;

  const CreateSceneCommand({
    required this.name,
    required this.genre,
    required this.type,
  });
}

/// create scene usecase
class CreateSceneUseCase {
  final SceneRepository _repository;
  final Transaction _transaction;
  final DomainEventBus _eventBus;
  final UniqueNameSpec _spec;

  CreateSceneUseCase({
    required SceneRepository repository,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _repository = repository,
        _transaction = transaction,
        _eventBus = eventBus,
        _spec = UniqueNameSpec(repository);

  Future<AppResult<SceneID, ApplicationException>> execute(
      CreateSceneCommand command) async {
    return await AppResult.monitor(() async {
      final scene = CreatedScene.create(
        id: SceneID.generate(),
        name: SceneName(command.name),
        genre: GenreName.fromName(command.genre),
        type: SceneTypeName.fromName(command.type),
      );

      await _transaction.transaction(() async {
        // unique name check
        if (!await _spec.isSatisfiedBy(scene)) {
          throw NotUniqueSceneNameException();
        }

        await _repository.store(scene);
      });

      _eventBus.publishes(scene.pullDomainEvents());

      return scene.id;
    });
  }
}
