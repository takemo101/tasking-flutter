import 'package:flutter/foundation.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/task/application/dto/task_data.dart';
import 'package:tasking/module/task/application/query/task_query.dart';
import 'package:tasking/module/task/application/usecase/change_task_operation_usecase.dart';
import 'package:tasking/module/task/application/usecase/discard_task_usecase.dart';
import 'package:tasking/module/task/application/usecase/discarded_task_list_usecase.dart';
import 'package:tasking/module/task/application/usecase/remove_task_usecase.dart';
import 'package:tasking/module/task/application/usecase/resume_task_usecase.dart';
import 'package:tasking/module/task/application/usecase/start_task_usecase.dart';
import 'package:tasking/module/task/application/usecase/started_task_list_usecase.dart';
import 'package:tasking/module/task/application/usecase/tidy_tasks_usecase.dart';
import 'package:tasking/module/task/domain/board_repository.dart';
import 'package:tasking/module/task/domain/task_repository.dart';

class TaskNotifier extends ChangeNotifier {
  final StartTaskUseCase _startUseCase;
  final ChangeTaskOperationUseCase _changeUseCase;
  final DiscardTaskUseCase _discardUseCase;
  final RemoveTaskUseCase _removeUseCase;
  final ResumeTaskUseCase _resumeUseCase;
  final TidyTasksUseCase _tidyTasksUseCase;
  final DiscardedTaskListUseCase _discardedListUseCase;
  final StartedTaskListUseCase _startedTaskListUseCase;

  final String _sceneID;

  List<TaskData> _discardedList = <TaskData>[];
  List<TaskData> _startedList = <TaskData>[];

  List<TaskData> get discardedList => List.unmodifiable(_discardedList);
  List<TaskData> get startedList => List.unmodifiable(_startedList);

  TaskNotifier(
    String sceneID, {
    required TaskRepository repository,
    required FlowRepository flowRepository,
    required BoardRepository boardRepository,
    required TaskQuery query,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _sceneID = sceneID,
        _startUseCase = StartTaskUseCase(
          repository: repository,
          boardRepository: boardRepository,
          flowRepository: flowRepository,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _changeUseCase = ChangeTaskOperationUseCase(
          repository: repository,
          flowRepository: flowRepository,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _discardUseCase = DiscardTaskUseCase(
          repository: repository,
          boardRepository: boardRepository,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _removeUseCase = RemoveTaskUseCase(
          repository: repository,
          transaction: transaction,
        ),
        _resumeUseCase = ResumeTaskUseCase(
          repository: repository,
          boardRepository: boardRepository,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _tidyTasksUseCase = TidyTasksUseCase(
          flowRepository: flowRepository,
          boardRepository: boardRepository,
          transaction: transaction,
        ),
        _discardedListUseCase = DiscardedTaskListUseCase(query: query),
        _startedTaskListUseCase = StartedTaskListUseCase(query: query);

  Future<void> start({
    required String content,
  }) async {
    await _startUseCase.execute(
      StartTaskCommand(
        sceneID: _sceneID,
        content: content,
      ),
    );

    startedListUpdate();
  }

  Future<void> changeOperation(String id) async {
    await _changeUseCase.execute(id);

    startedListUpdate();
  }

  Future<void> discard(String id) async {
    await _discardUseCase.execute(id);

    startedListUpdate();
    discardedListUpdate();
  }

  Future<void> resume(String id) async {
    await _resumeUseCase.execute(id);

    startedListUpdate();
    discardedListUpdate();
  }

  Future<void> remove(String id) async {
    await _removeUseCase.execute(id);

    discardedListUpdate();
  }

  Future<void> tidy() async {
    await _tidyTasksUseCase.execute(_sceneID);

    startedListUpdate();
  }

  void discardedListUpdate() {
    _discardedListUseCase.execute(_sceneID).then((list) {
      _discardedList = list;
      notifyListeners();
    });
  }

  void startedListUpdate() {
    _startedTaskListUseCase.execute(_sceneID).then((list) {
      _startedList = list;
      notifyListeners();
    });
  }
}
