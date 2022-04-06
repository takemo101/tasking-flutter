import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/application/dto/alarm_data.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/utility.dart';

/// alarm query mapper class
class AlarmQueryMapper {
  /// from map to alarm dto
  AlarmData fromMapToAlarmData(Map<String, dynamic> map) {
    return AlarmData(
      id: map['id'].toString(),
      content: map['content'].toString(),
      sceneID: map['scene_id'].toString(),
      lastModified: DateTime.parse(
        map['last_modified'].toString(),
      ),
    );
  }

  /// from map to alarm time dto
  AlarmTimeData fromMapsToAlarmTimeData(List<Map<String, dynamic>> maps) {
    final map = maps.first;

    return AlarmTimeData(
      id: map['id'].toString(),
      timeOfDay: TimeOfDay(hour: map['hour'], minute: map['minute']),
      dayOfWeeks: maps
          .map<DayOfWeek>((map) => DayOfWeekIndex.fromIndex(map['day_of_week']))
          .toList(),
      isActive: fromIntToBool(map['is_active']),
    );
  }
}
