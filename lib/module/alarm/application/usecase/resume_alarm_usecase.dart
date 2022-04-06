import 'package:tasking/module/alarm/domain/alarm.dart';
import 'package:tasking/module/alarm/domain/alarm_repository.dart';
import 'package:tasking/module/alarm/domain/alarm_time_notificator.dart';
import 'package:tasking/module/alarm/domain/subscriber/alarm_time_event_subscriber.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

/// resume alarm usecase
class ResumeAlarmUseCase {
  final AlarmRepository _repository;
  final AlarmResumedEventSubscriber _subscriber;
  final Transaction _transaction;
  final DomainEventBus _eventBus;

  ResumeAlarmUseCase({
    required AlarmRepository repository,
    required AlarmTimeNotificator notificator,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _repository = repository,
        _subscriber = AlarmResumedEventSubscriber(notificator),
        _transaction = transaction,
        _eventBus = eventBus;

  Future<AppResult<AlarmID, ApplicationException>> execute(
    String id,
  ) async {
    return await AppResult.monitor(() async {
      final alarm = await _transaction.transaction<Alarm>(() async {
        final alarm = await _repository.findDiscardedByID(AlarmID(id));

        if (alarm == null) {
          throw NotFoundException(id);
        }

        final resumed = alarm.resume();

        await _repository.update(resumed.item1);

        await _subscriber.handle(resumed.item2);

        return resumed.item1;
      });

      _eventBus.publishes(alarm.pullDomainEvents());

      return alarm.id;
    });
  }
}
