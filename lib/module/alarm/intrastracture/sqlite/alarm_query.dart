import 'package:tasking/module/alarm/application/dto/alarm_data.dart';
import 'package:tasking/module/alarm/application/query/alarm_query.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/alarm/intrastracture/sqlite/alarm_query_mapper.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';

class AlarmSQLiteQuery implements AlarmQuery {
  final SQLiteHelper _helper;

  final String _table = 'alarms';
  final String _timeTable = 'alarm_times';
  final String _dayOfWeekTable = 'alarm_day_of_weeks';

  final AlarmQueryMapper _mapper = AlarmQueryMapper();

  AlarmSQLiteQuery({
    required SQLiteHelper helper,
  }) : _helper = helper;

  @override
  Future<List<AlarmData>> allDiscardedBySceneID(SceneID sceneID) async {
    final executor = await _helper.executor();
    final maps = await executor.query(
      _table,
      where: 'scene_id = ? AND is_discarded = ?',
      whereArgs: [sceneID.value, 1],
      orderBy: 'last_modified DESC',
    );

    if (maps.isEmpty) {
      return <AlarmData>[];
    }

    return maps.map((data) => _mapper.fromMapToAlarmData(data)).toList();
  }

  @override
  Future<List<AlarmData>> allStartedBySceneID(SceneID sceneID) async {
    final executor = await _helper.executor();
    final maps = await executor.query(
      _table,
      where: 'scene_id = ? AND is_discarded = ?',
      whereArgs: [sceneID.value, 0],
      orderBy: 'last_modified DESC',
    );

    if (maps.isEmpty) {
      return <AlarmData>[];
    }

    return maps.map((data) => _mapper.fromMapToAlarmData(data)).toList();
  }

  @override
  Future<AlarmTimesData> oneAlarmTimesByAlarmID(AlarmID alarmID) async {
    final executor = await _helper.executor();

    final maps = await executor.query(
      _timeTable,
      where: 'alarm_id = ?',
      whereArgs: [alarmID.value],
      orderBy: 'hour ASC, minute ASC',
    );

    if (maps.isEmpty) {
      return AlarmTimesData(
        id: alarmID.value,
        times: const [],
      );
    }

    List<AlarmTimeData> times = [];

    for (final timeMap in maps) {
      final alarmTimeMaps = await executor.rawQuery(
        '''
          SELECT $_timeTable.*, $_dayOfWeekTable.day_of_week
          FROM $_timeTable
          INNER JOIN $_dayOfWeekTable
          ON $_timeTable.id = $_dayOfWeekTable.alarm_time_id
          WHERE $_timeTable.id = ?
        ''',
        [timeMap['id']],
      );

      if (alarmTimeMaps.isNotEmpty) {
        times.add(
          _mapper.fromMapsToAlarmTimeData(alarmTimeMaps),
        );
      }
    }

    return AlarmTimesData(
      id: alarmID.value,
      times: times,
    );
  }
}
