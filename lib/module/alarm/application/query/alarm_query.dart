import 'package:tasking/module/alarm/application/dto/alarm_data.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';

/// alarm query service interface
abstract class AlarmQuery {
  Future<List<AlarmData>> allStartedBySceneID(SceneID sceneID);
  Future<List<AlarmData>> allDiscardedBySceneID(SceneID sceneID);
  Future<AlarmTimesData> oneAlarmTimesByAlarmID(AlarmID alarmID);
}
