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

/// remove alarm time usecase
class RemoveAlarmTimeUseCase {
  final AlarmRepository _repository;
  final AlarmTimeRemovedEventSubscriber _subscriber;
  final Transaction _transaction;
  final DomainEventBus _eventBus;

  RemoveAlarmTimeUseCase({
    required AlarmRepository repository,
    required AlarmTimeNotificator notificator,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _repository = repository,
        _subscriber = AlarmTimeRemovedEventSubscriber(notificator),
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

        final removed = alarm.removeTime(AlarmTimeID(timeID));

        await _repository.update(removed.item1);

        await _subscriber.handle(removed.item2);

        return removed.item1;
      });

      _eventBus.publishes(alarm.pullDomainEvents());

      return alarm.id;
    });
  }
}
