import 'package:tasking/module/alarm/domain/alarm.dart';
import 'package:tasking/module/alarm/domain/alarm_repository.dart';
import 'package:tasking/module/alarm/domain/alarm_time_notificator.dart';
import 'package:tasking/module/alarm/domain/subscriber/alarm_time_event_subscriber.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_time_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

/// toggle alarm time usecase
class ToggleAlarmTimeUseCase {
  final AlarmRepository _repository;
  final AlarmTimeToggledEventSubscriber _subscriber;
  final Transaction _transaction;
  final DomainEventBus _eventBus;

  ToggleAlarmTimeUseCase({
    required AlarmRepository repository,
    required AlarmTimeNotificator notificator,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _repository = repository,
        _subscriber = AlarmTimeToggledEventSubscriber(notificator),
        _transaction = transaction,
        _eventBus = eventBus;

  Future<AppResult<AlarmID, ApplicationException>> execute(
    String id,
    String timeID,
  ) async {
    return await AppResult.monitor(() async {
      final alarm = await _transaction.transaction<Alarm>(() async {
        final alarm = await _repository.findStartedByID(
          AlarmID(id),
        );

        if (alarm == null) {
          throw NotFoundException(id);
        }

        final toggled = alarm.toggleTimeOnOff(AlarmTimeID(timeID));

        await _repository.update(toggled.item1);

        await _subscriber.handle(toggled.item2);

        return toggled.item1;
      });

      _eventBus.publishes(alarm.pullDomainEvents());

      return alarm.id;
    });
  }
}
