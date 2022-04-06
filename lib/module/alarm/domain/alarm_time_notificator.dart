import 'package:tasking/module/alarm/domain/entity/alarm_time.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_content.dart';

abstract class AlarmTimeNotificator {
  Future<void> make(AlarmContent content, AlarmTime time);
  Future<void> cancel(AlarmTime time);
}
