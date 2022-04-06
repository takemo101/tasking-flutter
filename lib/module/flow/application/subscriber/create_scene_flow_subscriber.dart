import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/scene/domain/event/scene_event.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

class CreateSceneFlowSubscriber
    implements EventSubscriber<CreateTaskSceneEvent> {
  final FlowRepository _repository;
  final Transaction _transaction;

  CreateSceneFlowSubscriber({
    required FlowRepository repository,
    required Transaction transaction,
  })  : _repository = repository,
        _transaction = transaction;

  @override
  void handle(CreateTaskSceneEvent event) async {
    await _transaction.transaction(() async {
      await _repository.save(
        Flow.create(id: event.id),
      );
    });
  }
}
