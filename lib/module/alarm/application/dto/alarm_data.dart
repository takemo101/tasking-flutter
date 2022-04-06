import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/domain/collection/alarm_times.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';

@immutable
class AlarmData {
  final String id;
  final String content;
  final String sceneID;
  final DateTime lastModified;

  const AlarmData({
    required this.id,
    required this.content,
    required this.sceneID,
    required this.lastModified,
  });
}

@immutable
class AlarmTimesData {
  final String id;
  final List<AlarmTimeData> times;

  const AlarmTimesData({
    required this.id,
    required this.times,
  });

  bool get canAddTime => times.length < AlarmTimes.limit;
}

@immutable
class AlarmTimeData {
  final String id;
  final TimeOfDay timeOfDay;
  final List<DayOfWeek> dayOfWeeks;
  final bool isActive;

  const AlarmTimeData({
    required this.id,
    required this.timeOfDay,
    required this.dayOfWeeks,
    required this.isActive,
  });
}

/// day of week string extension
extension DayOfWeekJPName on DayOfWeek {
  /// english jp name map
  static final _jpnames = {
    DayOfWeek.monday: "月",
    DayOfWeek.tuesday: "火",
    DayOfWeek.wednesday: "水",
    DayOfWeek.thursday: "木",
    DayOfWeek.friday: "金",
    DayOfWeek.saturday: "土",
    DayOfWeek.sunday: "日",
  };

  /// get string jp name
  String get jpname => _jpnames[this] ?? "";
}
