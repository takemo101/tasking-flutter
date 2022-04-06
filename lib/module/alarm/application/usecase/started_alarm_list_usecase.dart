import 'package:tasking/module/alarm/application/dto/alarm_data.dart';
import 'package:tasking/module/alarm/application/query/alarm_query.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';

/// started alarm list usecase
class StartedAlarmListUseCase {
  final AlarmQuery _query;

  StartedAlarmListUseCase({
    required AlarmQuery query,
  }) : _query = query;

  Future<AppResult<List<AlarmData>, ApplicationException>> execute(
    String sceneID,
  ) async {
    return await AppResult.monitor(
        () async => await _query.allStartedBySceneID(SceneID(sceneID)));
  }
}
