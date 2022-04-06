import 'package:tasking/module/alarm/domain/alarm.dart';
import 'package:tasking/module/alarm/domain/collection/alarm_times.dart';
import 'package:tasking/module/alarm/domain/entity/alarm_time.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_content.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_day_of_weeks.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_last_modified.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_notif_time_of_day.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_time_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/utility.dart';

/// alarm repository mapper class
class AlarmRepositoryMapper {
  /// from created alarm to alarm map
  Map<String, dynamic> fromCreatedAlarmToAlarmMap(CreatedAlarm alarm) {
    return {
      'id': alarm.id.value,
      'content': alarm.content.value,
      'scene_id': alarm.sceneID.value,
      'last_modified': alarm.lastModified.toString(),
      'is_discarded': fromBoolToInt(alarm.isDiscarded),
    };
  }

  /// from alarm time to alarm time map
  Map<String, dynamic> fromAlarmTimeToAlarmTimeMap(AlarmID id, AlarmTime time) {
    return {
      'id': time.id.value,
      'alarm_id': id.value,
      'hour': time.timeOfDay.hour,
      'minute': time.timeOfDay.minute,
      'is_active': fromBoolToInt(time.onOff),
    };
  }

  /// from created alarm to alarm time map list
  Map<String, dynamic> fromAlarmDayOfWeekToAlarmDayOfWeekMap(
      AlarmTimeID timeID, DayOfWeek week) {
    return {
      'alarm_time_id': timeID.value,
      'day_of_week': week.index,
    };
  }

  /// from map to started alarm aggregate
  StartedAlarm fromMapToStartedAlarm(
    Map<String, dynamic> alarmMap,
    AlarmTimes times,
  ) {
    return StartedAlarm.reconstruct(
      id: AlarmID(alarmMap['id'].toString()),
      content: AlarmContent(alarmMap['content'].toString()),
      times: times,
      sceneID: SceneID(alarmMap['scene_id'].toString()),
      lastModified:
          AlarmLastModified.fromString(alarmMap['last_modified'].toString()),
    );
  }

  /// from map to discarded alarm aggregate
  DiscardedAlarm fromMapToDiscardedAlarm(
    Map<String, dynamic> alarmMap,
    AlarmTimes times,
  ) {
    return DiscardedAlarm.reconstruct(
      id: AlarmID(alarmMap['id'].toString()),
      content: AlarmContent(alarmMap['content'].toString()),
      times: times,
      sceneID: SceneID(alarmMap['scene_id'].toString()),
      lastModified:
          AlarmLastModified.fromString(alarmMap['last_modified'].toString()),
    );
  }

  /// from map list to alarm times collection
  AlarmTime fromMapsToAlarmTime(List<Map<String, dynamic>> maps) {
    final map = maps.first;

    return AlarmTime.reconstruct(
      fromIntToBool(map['is_active']),
      id: AlarmTimeID(map['id'].toString()),
      timeOfDay: AlarmNotifTimeOfDay.fromNumber(map['hour'], map['minute']),
      dayOfWeeks: map['day_of_week'] == null
          ? AlarmDayOfWeeks.empty()
          : fromMapsToAlarmDayOfWeeks(maps),
    );
  }

  /// from map list to day of weeks collection
  AlarmDayOfWeeks fromMapsToAlarmDayOfWeeks(List<Map<String, dynamic>> maps) {
    return AlarmDayOfWeeks.fromIndexes(
      maps.map<int>((map) => map['day_of_week']).toList(),
    );
  }
}
