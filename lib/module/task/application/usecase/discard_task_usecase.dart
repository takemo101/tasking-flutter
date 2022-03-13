import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/task_repository.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

/// discard task usecase
class DiscardTaskUseCase {
  final TaskRepository _repository;
  final Transaction _transaction;
  final DomainEventBus _eventBus;

  DiscardTaskUseCase({
    required TaskRepository repository,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _repository = repository,
        _transaction = transaction,
        _eventBus = eventBus;

  Future<void> execute(String id) async {
    final task = await _transaction.transaction<Task>(() async {
      final task = await _repository.findStartedByID(TaskID(id));

      if (task == null) {
        throw NotFoundException(id, name: 'task');
      }

      await _repository.update(task.discard());

      return task;
    });

    _eventBus.publishes(task.pullDomainEvents());
  }
}
