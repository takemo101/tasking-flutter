import 'package:tasking/module/alarm/domain/alarm.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';

abstract class AlarmRepository {
  Future<StartedAlarm?> findStartedByID(AlarmID id);
  Future<DiscardedAlarm?> findDiscardedByID(AlarmID id);
  Future<void> store(CreatedAlarm alarm);
  Future<void> update(CreatedAlarm alarm);
  Future<void> remove(RemovedAlarm alarm);
}
