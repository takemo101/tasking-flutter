import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/task/domain/service/change_to_next_operation.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/task_repository.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

/// change task operation usecase
class ChangeTaskOperationUseCase {
  final TaskRepository _repository;
  final ChangeToNextOperation _service;
  final Transaction _transaction;
  final DomainEventBus _eventBus;

  ChangeTaskOperationUseCase({
    required TaskRepository repository,
    required FlowRepository flowRepository,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _repository = repository,
        _service = ChangeToNextOperation(flowRepository),
        _transaction = transaction,
        _eventBus = eventBus;

  Future<AppResult<TaskID, ApplicationException>> execute(String id) async {
    return await AppResult.monitor(() async {
      final task = await _transaction.transaction<Task>(() async {
        final task = await _repository.findStartedByID(
          TaskID(id),
        );

        if (task == null) {
          throw NotFoundException(id);
        }

        final startedTask = await _service.changeToNextOperation(task);

        await _repository.update(startedTask);

        return startedTask;
      });

      _eventBus.publishes(task.pullDomainEvents());

      return task.id;
    });
  }
}
