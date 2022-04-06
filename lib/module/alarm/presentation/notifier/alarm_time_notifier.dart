import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/application/dto/alarm_data.dart';
import 'package:tasking/module/alarm/application/query/alarm_query.dart';
import 'package:tasking/module/alarm/application/usecase/add_alarm_time_usecase.dart';
import 'package:tasking/module/alarm/application/usecase/alarm_time_list_usecase.dart';
import 'package:tasking/module/alarm/application/usecase/change_alarm_time_usecase.dart';
import 'package:tasking/module/alarm/application/usecase/remove_alarm_time_usecase.dart';
import 'package:tasking/module/alarm/application/usecase/toggle_alarm_time_usecase.dart';
import 'package:tasking/module/alarm/domain/alarm_repository.dart';
import 'package:tasking/module/alarm/domain/alarm_time_notificator.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';

class AlarmTimeNotifier extends ChangeNotifier {
  final AddAlarmTimeUseCase _addUseCase;
  final ChangeAlarmTimeUseCase _changeUseCase;
  final RemoveAlarmTimeUseCase _removeUseCase;
  final ToggleAlarmTimeUseCase _toggleUseCase;
  final AlarmTimeListUseCase _alarmTimeListUseCase;

  final String _alarmID;

  AlarmTimesData _alarmTimes;

  AlarmTimesData get alarmTimes => _alarmTimes;

  AlarmTimeNotifier(
    String alarmID, {
    required AlarmRepository repository,
    required AlarmQuery query,
    required AlarmTimeNotificator notificator,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _alarmID = alarmID,
        _alarmTimes = AlarmTimesData(id: alarmID, times: const []),
        _addUseCase = AddAlarmTimeUseCase(
          repository: repository,
          notificator: notificator,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _changeUseCase = ChangeAlarmTimeUseCase(
          repository: repository,
          notificator: notificator,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _removeUseCase = RemoveAlarmTimeUseCase(
          repository: repository,
          notificator: notificator,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _toggleUseCase = ToggleAlarmTimeUseCase(
          repository: repository,
          notificator: notificator,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _alarmTimeListUseCase = AlarmTimeListUseCase(query: query);

  Future<AppResult<AlarmID, ApplicationException>> add({
    required TimeOfDay timeOfDay,
    required List<DayOfWeek> dayOfWeeks,
  }) async {
    return await _addUseCase.execute(
      AddAlarmTimeCommand(
        id: _alarmID,
        timeOfDay: timeOfDay,
        dayOfWeeks: dayOfWeeks,
      ),
    )
      ..onSuccess((_) => timesUpdate());
  }

  Future<AppResult<AlarmID, ApplicationException>> change({
    required String timeID,
    required TimeOfDay timeOfDay,
    required List<DayOfWeek> dayOfWeeks,
  }) async {
    return await _changeUseCase.execute(
      ChangeAlarmTimeCommand(
        id: _alarmID,
        timeID: timeID,
        timeOfDay: timeOfDay,
        dayOfWeeks: dayOfWeeks,
      ),
    )
      ..onSuccess((_) {
        timesUpdate();
      });
  }

  Future<AppResult<AlarmID, ApplicationException>> toggle(String timeID) async {
    return await _toggleUseCase.execute(_alarmID, timeID)
      ..onSuccess((_) => timesUpdate());
  }

  Future<AppResult<AlarmID, ApplicationException>> remove(String timeID) async {
    return await _removeUseCase.execute(_alarmID, timeID)
      ..onSuccess((_) => timesUpdate());
  }

  void timesUpdate() {
    _alarmTimeListUseCase.execute(_alarmID).then((result) {
      result.onSuccess((times) {
        _alarmTimes = times;
        notifyListeners();
      });
    });
  }
}
