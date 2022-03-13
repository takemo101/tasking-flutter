import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/task/domain/event/task_event.dart';

class StartTaskSceneSubscriber implements EventSubscriber<StartTaskEvent> {
  final SceneRepository _repository;
  final Transaction _transaction;

  StartTaskSceneSubscriber({
    required SceneRepository repository,
    required Transaction transaction,
  })  : _repository = repository,
        _transaction = transaction;
  @override
  void handle(StartTaskEvent event) async {
    await _transaction.transaction(() async {
      final scene = await _repository.findByID(event.sceneID);

      if (scene != null) {
        _repository.update(scene.updateActivity());
      }
    });
  }
}
