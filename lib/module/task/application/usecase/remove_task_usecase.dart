import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/task/domain/task_repository.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

/// remove task usecase
class RemoveTaskUseCase {
  final TaskRepository _repository;
  final Transaction _transaction;

  RemoveTaskUseCase({
    required TaskRepository repository,
    required Transaction transaction,
  })  : _repository = repository,
        _transaction = transaction;

  Future<void> execute(String id) async {
    await _transaction.transaction(() async {
      final task = await _repository.findDiscardedByID(TaskID(id));

      if (task == null) {
        throw NotFoundException(id, name: 'task');
      }

      await _repository.remove(task.remove());
    });
  }
}
