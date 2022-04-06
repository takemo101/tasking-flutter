import 'package:tasking/module/alarm/domain/alarm.dart';
import 'package:tasking/module/alarm/domain/alarm_repository.dart';
import 'package:tasking/module/alarm/domain/collection/alarm_times.dart';
import 'package:tasking/module/alarm/domain/entity/alarm_time.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/alarm/intrastracture/sqlite/alarm_repository_mapper.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:sqflite/sqflite.dart';

class AlarmSQLiteRepository implements AlarmRepository {
  final SQLiteHelper _helper;

  final String _table = 'alarms';
  final String _timeTable = 'alarm_times';
  final String _dayOfWeekTable = 'alarm_day_of_weeks';

  final AlarmRepositoryMapper _mapper = AlarmRepositoryMapper();

  AlarmSQLiteRepository({required SQLiteHelper helper}) : _helper = helper;

  @override
  Future<StartedAlarm?> findStartedByID(AlarmID id) async {
    final executor = await _helper.executor();
    final maps = await executor.rawQuery(
      '''
        SELECT $_table.*, $_timeTable.id AS alarm_time_id, $_timeTable.hour, $_timeTable.minute, $_timeTable.is_active
        FROM $_table
        LEFT OUTER JOIN $_timeTable
        ON $_table.id = $_timeTable.alarm_id
        WHERE $_table.id = ? AND $_table.is_discarded = ?
      ''',
      [id.value, 0],
    );

    if (maps.isEmpty) {
      return null;
    }

    final alarmMap = maps.first;
    List<AlarmTime> times = [];

    for (final timeMap in maps) {
      if (!timeMap.containsKey('alarm_time_id') ||
          timeMap['alarm_time_id'] == null) {
        break;
      }

      final alarmTimeMaps = await executor.rawQuery(
        '''
          SELECT $_timeTable.*, $_dayOfWeekTable.day_of_week
          FROM $_timeTable
          LEFT OUTER JOIN $_dayOfWeekTable
          ON $_timeTable.id = $_dayOfWeekTable.alarm_time_id
          WHERE $_timeTable.id = ?
        ''',
        [timeMap['alarm_time_id']],
      );

      if (alarmTimeMaps.isNotEmpty) {
        times.add(
          _mapper.fromMapsToAlarmTime(alarmTimeMaps),
        );
      }
    }

    return _mapper.fromMapToStartedAlarm(alarmMap, AlarmTimes(times));
  }

  @override
  Future<DiscardedAlarm?> findDiscardedByID(AlarmID id) async {
    final executor = await _helper.executor();
    final maps = await executor.rawQuery(
      '''
        SELECT $_table.*, $_timeTable.id AS alarm_time_id, $_timeTable.hour, $_timeTable.minute, $_timeTable.is_active
        FROM $_table
        LEFT OUTER JOIN $_timeTable
        ON $_table.id = $_timeTable.alarm_id
        WHERE $_table.id = ? AND $_table.is_discarded = ?
      ''',
      [id.value, 1],
    );

    if (maps.isEmpty) {
      return null;
    }

    final alarmMap = maps.first;
    List<AlarmTime> times = [];

    for (final timeMap in maps) {
      if (!timeMap.containsKey('alarm_time_id') ||
          timeMap['alarm_time_id'] == null) {
        break;
      }

      final alarmTimeMaps = await executor.rawQuery(
        '''
          SELECT $_timeTable.*, $_dayOfWeekTable.day_of_week
          FROM $_timeTable
          LEFT OUTER JOIN $_dayOfWeekTable
          ON $_timeTable.id = $_dayOfWeekTable.alarm_time_id
          WHERE $_timeTable.id = ?
        ''',
        [timeMap['alarm_time_id']],
      );

      if (alarmTimeMaps.isNotEmpty) {
        times.add(
          _mapper.fromMapsToAlarmTime(alarmTimeMaps),
        );
      }
    }

    return _mapper.fromMapToDiscardedAlarm(alarmMap, AlarmTimes(times));
  }

  @override
  Future<void> remove(RemovedAlarm alarm) async {
    final executor = await _helper.executor();
    await executor.delete(
      _table,
      where: "id = ?",
      whereArgs: [alarm.id.value],
    );
  }

  @override
  Future<void> store(CreatedAlarm alarm) async {
    final executor = await _helper.executor();

    await executor.insert(
      _table,
      _mapper.fromCreatedAlarmToAlarmMap(alarm),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (final time in alarm.times.times) {
      final map = _mapper.fromAlarmTimeToAlarmTimeMap(alarm.id, time);
      await executor.insert(
        _timeTable,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (final week in time.dayOfWeeks.value) {
        final map = _mapper.fromAlarmDayOfWeekToAlarmDayOfWeekMap(
          time.id,
          week,
        );

        await executor.insert(
          _dayOfWeekTable,
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  @override
  Future<void> update(CreatedAlarm alarm) async {
    final executor = await _helper.executor();
    await executor.update(
      _table,
      _mapper.fromCreatedAlarmToAlarmMap(alarm),
      where: "id = ?",
      whereArgs: [alarm.id.value],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    await executor.delete(
      _timeTable,
      where: "alarm_id = ?",
      whereArgs: [alarm.id.value],
    );

    for (final time in alarm.times.times) {
      final map = _mapper.fromAlarmTimeToAlarmTimeMap(alarm.id, time);
      await executor.insert(
        _timeTable,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (final week in time.dayOfWeeks.value) {
        final map = _mapper.fromAlarmDayOfWeekToAlarmDayOfWeekMap(
          time.id,
          week,
        );

        await executor.insert(
          _dayOfWeekTable,
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }
}
