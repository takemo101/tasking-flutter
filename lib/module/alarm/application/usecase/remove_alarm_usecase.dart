import 'package:tasking/module/alarm/domain/alarm_repository.dart';
import 'package:tasking/module/alarm/domain/alarm_time_notificator.dart';
import 'package:tasking/module/alarm/domain/subscriber/alarm_time_event_subscriber.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

/// remove alarm usecase
class RemoveAlarmUseCase {
  final AlarmRepository _repository;
  final AlarmRemovedEventSubscriber _subscriber;
  final Transaction _transaction;

  RemoveAlarmUseCase({
    required AlarmRepository repository,
    required AlarmTimeNotificator notificator,
    required Transaction transaction,
  })  : _repository = repository,
        _subscriber = AlarmRemovedEventSubscriber(notificator),
        _transaction = transaction;

  Future<AppResult<AlarmID, ApplicationException>> execute(String id) async {
    return await AppResult.monitor(() async {
      return await _transaction.transaction(() async {
        final alarm = await _repository.findDiscardedByID(AlarmID(id));

        if (alarm == null) {
          throw NotFoundException(id);
        }

        final removed = alarm.remove();

        await _repository.remove(removed.item1);

        await _subscriber.handle(removed.item2);

        return removed.item1.id;
      });
    });
  }
}
