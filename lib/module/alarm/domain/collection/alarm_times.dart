import 'package:tasking/module/alarm/domain/entity/alarm_time.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_day_of_weeks.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_notif_time_of_day.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_time_id.dart';
import 'package:tasking/module/shared/domain/exception.dart';

/// alarm time collection mutable class
class AlarmTimes {
  static const limit = 7;

  final List<AlarmTime> _times = [];

  AlarmTimes(
    List<AlarmTime> times,
  ) {
    for (final time in times) {
      add(time);
    }
  }

  /// create empty data constructor
  AlarmTimes.empty() : this(<AlarmTime>[]);

  /// has by day of time
  bool hasByTimeOfDay(AlarmNotifTimeOfDay timeOfDay) {
    return _times.indexWhere((tm) => tm.timeOfDay == timeOfDay) != -1;
  }

  /// has by day of time
  bool hasByTimeOfDayExceptID(AlarmNotifTimeOfDay timeOfDay, AlarmTimeID id) {
    return _times
            .indexWhere((tm) => tm.id != id && tm.timeOfDay == timeOfDay) !=
        -1;
  }

  /// has by alarm time id
  bool hasByID(AlarmTimeID id) {
    return _times.indexWhere((tm) => tm.id == id) != -1;
  }

  /// add alarm time
  void add(AlarmTime time) {
    if (_times.length >= AlarmTimes.limit) {
      throw DomainException(
        type: DomainExceptionType.size,
        detail: 'list size of the alarm time is too large!',
      );
    }

    // duplicate check
    if (hasByTimeOfDay(time.timeOfDay)) {
      throw DomainException(
        type: DomainExceptionType.duplicate,
        detail: 'day of time is duplicated!',
        jp: '通知時間が重複しています！',
      );
    }

    _times.add(time);
  }

  /// change alarm time by id
  AlarmTime changeByID(
    AlarmTimeID id,
    AlarmNotifTimeOfDay timeOfDay,
    AlarmDayOfWeeks dayOfWeeks,
  ) {
    final index = _times.indexWhere((tm) => tm.id == id);

    // change alarm time
    if (index != -1) {
      final time = _times[index].changeTime(
        timeOfDay: timeOfDay,
        dayOfWeeks: dayOfWeeks,
      );
      _times[index] = time;

      return time;
    }

    throw DomainException(
      type: DomainExceptionType.notFound,
      detail: 'not found [id = ${id.value}] alarm time!',
    );
  }

  /// toggle alarm time on/off by id
  AlarmTime toggleByID(AlarmTimeID id) {
    final index = _times.indexWhere((tm) => tm.id == id);

    if (index != -1) {
      _times[index] = _times[index].toggleOnOff();

      return _times[index];
    }

    throw DomainException(
      type: DomainExceptionType.notFound,
      detail: 'not found [id = ${id.value}] alarm time!',
    );
  }

  /// remove alarm time by id
  AlarmTime removeByID(AlarmTimeID id) {
    final index = _times.indexWhere((tm) => tm.id == id);

    if (index != -1) {
      final time = _times.removeAt(index);

      return time;
    }

    throw DomainException(
      type: DomainExceptionType.notFound,
      detail: 'not found [id = ${id.value}] alarm time!',
    );
  }

  /// get alarm time list
  List<AlarmTime> get times => [..._times];

  /// get alarm on time list
  List<AlarmTimeOn> get onTimes =>
      [..._times.where((tm) => tm.onOff).cast<AlarmTimeOn>()];

  /// get alarm off time list
  List<AlarmTimeOff> get offTimes =>
      [..._times.where((tm) => !tm.onOff).cast<AlarmTimeOff>()];

  /// get clone
  AlarmTimes get clone => AlarmTimes(times);
}
