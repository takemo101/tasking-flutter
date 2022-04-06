import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/task/domain/board_repository.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/task_repository.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

/// resume task usecase
class ResumeTaskUseCase {
  final TaskRepository _repository;
  final BoardRepository _boardRepository;
  final Transaction _transaction;
  final DomainEventBus _eventBus;

  ResumeTaskUseCase({
    required TaskRepository repository,
    required BoardRepository boardRepository,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _repository = repository,
        _boardRepository = boardRepository,
        _transaction = transaction,
        _eventBus = eventBus;

  Future<AppResult<TaskID, ApplicationException>> execute(String id) async {
    return await AppResult.monitor(() async {
      final task = await _transaction.transaction<Task>(() async {
        final task = await _repository.findDiscardedByID(TaskID(id));

        if (task == null) {
          throw NotFoundException(id);
        }

        final startedTask = task.resume();

        await _repository.update(startedTask);

        final board = await _boardRepository.findByID(task.sceneID);

        await _boardRepository.save(
          board.addPinByStartedTask(startedTask),
        );

        return startedTask;
      });

      _eventBus.publishes(task.pullDomainEvents());

      return task.id;
    });
  }
}
