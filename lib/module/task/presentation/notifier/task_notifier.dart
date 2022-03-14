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
import 'package:tasking/module/task/domain/board_repository.dart';
import 'package:tasking/module/task/domain/task_repository.dart';

class TaskNotifier extends ChangeNotifier {
  final StartTaskUseCase _startUseCase;
  final ChangeTaskOperationUseCase _changeUseCase;
  final DiscardTaskUseCase _discardUseCase;
  final RemoveTaskUseCase _removeUseCase;
  final ResumeTaskUseCase _resumeUseCase;
  final DiscardedTaskListUseCase _discardedListUseCase;
  final StartedTaskListUseCase _startedTaskListUseCase;

  List<TaskData> _discardedList = <TaskData>[];
  List<TaskData> _startedList = <TaskData>[];

  List<TaskData> get discardedList => List.unmodifiable(_discardedList);
  List<TaskData> get startedList => List.unmodifiable(_startedList);

  TaskNotifier({
    required TaskRepository repository,
    required FlowRepository flowRepository,
    required BoardRepository boardRepository,
    required TaskQuery query,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _startUseCase = StartTaskUseCase(
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
        _discardedListUseCase = DiscardedTaskListUseCase(query: query),
        _startedTaskListUseCase = StartedTaskListUseCase(query: query);

  void start({
    required String sceneID,
    required String content,
  }) async {
    final id = await _startUseCase.execute(
      StartTaskCommand(
        sceneID: sceneID,
        content: content,
      ),
    );

    startedListUpdate(id.value);
  }

  void changeOperation(String id) async {
    await _changeUseCase.execute(id);

    startedListUpdate(id);
  }

  void discard(String id) async {
    await _discardUseCase.execute(id);

    startedListUpdate(id);
    discardedListUpdate(id);
  }

  void resume(String id) async {
    await _resumeUseCase.execute(id);

    startedListUpdate(id);
    discardedListUpdate(id);
  }

  void remove(String id) async {
    await _removeUseCase.execute(id);

    discardedListUpdate(id);
  }

  void discardedListUpdate(String id) {
    _discardedListUseCase.execute(id).then((list) {
      _discardedList = list;
      notifyListeners();
    });
  }

  void startedListUpdate(String id) {
    _startedTaskListUseCase.execute(id).then((list) {
      _startedList = list;
      notifyListeners();
    });
  }
}
