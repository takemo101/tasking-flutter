import 'package:flutter/foundation.dart';
import 'package:tasking/module/alarm/application/dto/alarm_data.dart';
import 'package:tasking/module/alarm/application/query/alarm_query.dart';
import 'package:tasking/module/alarm/application/usecase/discard_alarm_usecase.dart';
import 'package:tasking/module/alarm/application/usecase/discarded_alarm_list_usecase.dart';
import 'package:tasking/module/alarm/application/usecase/remove_alarm_usecase.dart';
import 'package:tasking/module/alarm/application/usecase/resume_alarm_usecase.dart';
import 'package:tasking/module/alarm/application/usecase/start_alarm_usecase.dart';
import 'package:tasking/module/alarm/application/usecase/started_alarm_list_usecase.dart';
import 'package:tasking/module/alarm/domain/alarm_repository.dart';
import 'package:tasking/module/alarm/domain/alarm_time_notificator.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

class AlarmNotifier extends ChangeNotifier {
  final StartAlarmUseCase _startUseCase;
  final DiscardAlarmUseCase _discardUseCase;
  final ResumeAlarmUseCase _resumeUseCase;
  final RemoveAlarmUseCase _removeUseCase;
  final DiscardedAlarmListUseCase _discardedListUseCase;
  final StartedAlarmListUseCase _startedTaskListUseCase;

  final String _sceneID;

  List<AlarmData> _discardedList = <AlarmData>[];
  List<AlarmData> _startedList = <AlarmData>[];

  List<AlarmData> get discardedList => List.unmodifiable(_discardedList);
  List<AlarmData> get startedList => List.unmodifiable(_startedList);

  AlarmNotifier(
    String sceneID, {
    required AlarmRepository repository,
    required SceneRepository sceneRepository,
    required AlarmQuery query,
    required AlarmTimeNotificator notificator,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _sceneID = sceneID,
        _startUseCase = StartAlarmUseCase(
          repository: repository,
          sceneRepository: sceneRepository,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _discardUseCase = DiscardAlarmUseCase(
          repository: repository,
          notificator: notificator,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _resumeUseCase = ResumeAlarmUseCase(
          repository: repository,
          notificator: notificator,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _removeUseCase = RemoveAlarmUseCase(
          repository: repository,
          notificator: notificator,
          transaction: transaction,
        ),
        _discardedListUseCase = DiscardedAlarmListUseCase(query: query),
        _startedTaskListUseCase = StartedAlarmListUseCase(query: query);

  Future<AppResult<AlarmID, ApplicationException>> start({
    required String content,
  }) async {
    return await _startUseCase.execute(
      StartAlarmCommand(
        sceneID: _sceneID,
        content: content,
      ),
    )
      ..onSuccess((_) => startedListUpdate());
  }

  Future<AppResult<AlarmID, ApplicationException>> discard(String id) async {
    return await _discardUseCase.execute(id)
      ..onSuccess((_) {
        startedListUpdate();
        discardedListUpdate();
      });
  }

  Future<AppResult<AlarmID, ApplicationException>> resume(String id) async {
    return await _resumeUseCase.execute(id)
      ..onSuccess((_) {
        startedListUpdate();
        discardedListUpdate();
      });
  }

  Future<AppResult<AlarmID, ApplicationException>> remove(String id) async {
    return await _removeUseCase.execute(id)
      ..onSuccess((_) => discardedListUpdate());
  }

  void discardedListUpdate() {
    _discardedListUseCase.execute(_sceneID).then((result) {
      result.onSuccess((list) {
        _discardedList = list;
        notifyListeners();
      });
    });
  }

  void startedListUpdate() {
    _startedTaskListUseCase.execute(_sceneID).then((result) {
      result.onSuccess((list) {
        _startedList = list;
        notifyListeners();
      });
    });
  }
}
