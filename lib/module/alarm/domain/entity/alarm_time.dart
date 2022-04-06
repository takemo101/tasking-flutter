import 'package:meta/meta.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_notif_time_of_day.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_day_of_weeks.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_time_id.dart';

abstract class AlarmTime {
  final AlarmTimeID id;
  final AlarmNotifTimeOfDay timeOfDay;
  final AlarmDayOfWeeks dayOfWeeks;

  /// private constructor
  const AlarmTime._({
    required this.id,
    required this.timeOfDay,
    required this.dayOfWeeks,
  });

  bool get onOff => true;

  /// change alarm time
  AlarmTime changeTime({
    required AlarmNotifTimeOfDay timeOfDay,
    required AlarmDayOfWeeks dayOfWeeks,
  });

  /// on off toggle
  AlarmTime toggleOnOff();

  static AlarmTime reconstruct(
    bool onOff, {
    required AlarmTimeID id,
    required AlarmNotifTimeOfDay timeOfDay,
    required AlarmDayOfWeeks dayOfWeeks,
  }) {
    return onOff
        ? AlarmTimeOn.reconstruct(
            id: id,
            timeOfDay: timeOfDay,
            dayOfWeeks: dayOfWeeks,
          )
        : AlarmTimeOff.reconstruct(
            id: id,
            timeOfDay: timeOfDay,
            dayOfWeeks: dayOfWeeks,
          );
  }

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is AlarmTime && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}

@immutable
class AlarmTimeOn extends AlarmTime {
  /// private constructor
  const AlarmTimeOn._({
    required AlarmTimeID id,
    required AlarmNotifTimeOfDay timeOfDay,
    required AlarmDayOfWeeks dayOfWeeks,
  }) : super._(
          id: id,
          timeOfDay: timeOfDay,
          dayOfWeeks: dayOfWeeks,
        );

  /// reconstruct
  const AlarmTimeOn.reconstruct({
    required AlarmTimeID id,
    required AlarmNotifTimeOfDay timeOfDay,
    required AlarmDayOfWeeks dayOfWeeks,
  }) : this._(
          id: id,
          timeOfDay: timeOfDay,
          dayOfWeeks: dayOfWeeks,
        );

  AlarmTimeOn.create({
    required AlarmNotifTimeOfDay timeOfDay,
    required AlarmDayOfWeeks dayOfWeeks,
  }) : this._(
          id: AlarmTimeID.generate(),
          timeOfDay: timeOfDay,
          dayOfWeeks: dayOfWeeks,
        );

  @override
  AlarmTime changeTime({
    required AlarmNotifTimeOfDay timeOfDay,
    required AlarmDayOfWeeks dayOfWeeks,
  }) {
    return AlarmTimeOn._(
      id: id,
      timeOfDay: timeOfDay,
      dayOfWeeks: dayOfWeeks,
    );
  }

  @override
  AlarmTime toggleOnOff() {
    return AlarmTimeOff._(
      id: id,
      timeOfDay: timeOfDay,
      dayOfWeeks: dayOfWeeks,
    );
  }
}

@immutable
class AlarmTimeOff extends AlarmTime {
  /// private constructor
  const AlarmTimeOff._({
    required AlarmTimeID id,
    required AlarmNotifTimeOfDay timeOfDay,
    required AlarmDayOfWeeks dayOfWeeks,
  }) : super._(
          id: id,
          timeOfDay: timeOfDay,
          dayOfWeeks: dayOfWeeks,
        );

  /// reconstruct
  const AlarmTimeOff.reconstruct({
    required AlarmTimeID id,
    required AlarmNotifTimeOfDay timeOfDay,
    required AlarmDayOfWeeks dayOfWeeks,
  }) : this._(
          id: id,
          timeOfDay: timeOfDay,
          dayOfWeeks: dayOfWeeks,
        );

  @override
  bool get onOff => false;

  @override
  AlarmTime changeTime({
    required AlarmNotifTimeOfDay timeOfDay,
    required AlarmDayOfWeeks dayOfWeeks,
  }) {
    return AlarmTimeOff._(
      id: id,
      timeOfDay: timeOfDay,
      dayOfWeeks: dayOfWeeks,
    );
  }

  @override
  AlarmTime toggleOnOff() {
    return AlarmTimeOn._(
      id: id,
      timeOfDay: timeOfDay,
      dayOfWeeks: dayOfWeeks,
    );
  }
}
