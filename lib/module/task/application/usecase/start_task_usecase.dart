import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/task/domain/factory/start_default_task.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/task_repository.dart';
import 'package:tasking/module/task/domain/vo/task_content.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

/// start task command dto
@immutable
class StartTaskCommand {
  final String sceneID;
  final String content;

  const StartTaskCommand({
    required this.sceneID,
    required this.content,
  });
}

/// create scene usecase
class StartTaskUseCase {
  final TaskRepository _repository;
  final FlowRepository _flowRepository;
  final Transaction _transaction;
  final DomainEventBus _eventBus;

  StartTaskUseCase({
    required TaskRepository repository,
    required FlowRepository flowRepository,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _repository = repository,
        _flowRepository = flowRepository,
        _transaction = transaction,
        _eventBus = eventBus;

  Future<TaskID> execute(StartTaskCommand command) async {
    final task = await _transaction.transaction<Task>(() async {
      final flow = await _flowRepository.findByID(SceneID(command.sceneID));

      if (flow == null) {
        throw NotFoundException(command.sceneID, name: 'flow');
      }

      final factory = StartDefaultTask(flow);
      final task = factory.start(TaskContent(command.content));

      await _repository.store(task);

      return task;
    });

    _eventBus.publishes(task.pullDomainEvents());

    return task.id;
  }
}
