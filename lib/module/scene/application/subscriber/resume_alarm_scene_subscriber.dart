import 'package:tasking/module/alarm/domain/event/alarm_event.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

class ResumeAlarmSceneSubscriber implements EventSubscriber<ResumeAlarmEvent> {
  final SceneRepository _repository;
  final Transaction _transaction;

  ResumeAlarmSceneSubscriber({
    required SceneRepository repository,
    required Transaction transaction,
  })  : _repository = repository,
        _transaction = transaction;
  @override
  void handle(ResumeAlarmEvent event) async {
    await _transaction.transaction(() async {
      final scene = await _repository.findByID(event.sceneID);

      if (scene != null) {
        _repository.update(scene.updateActivity());
      }
    });
  }
}
