import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/domain/alarm.dart';
import 'package:tasking/module/alarm/domain/alarm_repository.dart';
import 'package:tasking/module/alarm/domain/alarm_time_notificator.dart';
import 'package:tasking/module/alarm/domain/subscriber/alarm_time_event_subscriber.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_day_of_weeks.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_notif_time_of_day.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_time_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';

@immutable
class ChangeAlarmTimeCommand {
  final String id;
  final String timeID;
  final TimeOfDay timeOfDay;
  final List<DayOfWeek> dayOfWeeks;

  const ChangeAlarmTimeCommand({
    required this.id,
    required this.timeID,
    required this.timeOfDay,
    required this.dayOfWeeks,
  });
}

/// change alarm time usecase
class ChangeAlarmTimeUseCase {
  final AlarmRepository _repository;
  final AlarmTimeChangedEventSubscriber _subscriber;
  final Transaction _transaction;
  final DomainEventBus _eventBus;

  ChangeAlarmTimeUseCase({
    required AlarmRepository repository,
    required AlarmTimeNotificator notificator,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _repository = repository,
        _subscriber = AlarmTimeChangedEventSubscriber(notificator),
        _transaction = transaction,
        _eventBus = eventBus;

  Future<AppResult<AlarmID, ApplicationException>> execute(
    ChangeAlarmTimeCommand command,
  ) async {
    return await AppResult.monitor(() async {
      final alarm = await _transaction.transaction<Alarm>(() async {
        final alarm = await _repository.findStartedByID(
          AlarmID(command.id),
        );

        if (alarm == null) {
          throw NotFoundException(command.id);
        }

        final changed = alarm.changeTime(
          AlarmTimeID(command.timeID),
          AlarmNotifTimeOfDay(command.timeOfDay),
          AlarmDayOfWeeks(command.dayOfWeeks),
        );

        await _repository.update(changed.item1);

        await _subscriber.handle(changed.item2);

        return changed.item1;
      });

      _eventBus.publishes(alarm.pullDomainEvents());

      return alarm.id;
    });
  }
}
