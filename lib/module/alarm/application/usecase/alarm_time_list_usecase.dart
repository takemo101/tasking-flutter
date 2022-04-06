import 'package:tasking/module/alarm/application/dto/alarm_data.dart';
import 'package:tasking/module/alarm/application/query/alarm_query.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';

/// alarm time list usecase
class AlarmTimeListUseCase {
  final AlarmQuery _query;

  AlarmTimeListUseCase({
    required AlarmQuery query,
  }) : _query = query;

  Future<AppResult<AlarmTimesData, ApplicationException>> execute(
    String alarmID,
  ) async {
    return await AppResult.monitor(
        () async => await _query.oneAlarmTimesByAlarmID(AlarmID(alarmID)));
  }
}
