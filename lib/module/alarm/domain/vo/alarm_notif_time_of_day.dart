import 'package:flutter/material.dart';
import 'package:tasking/module/shared/domain/exception.dart';

@immutable
class AlarmNotifTimeOfDay {
  final TimeOfDay _value;

  /// constructor
  AlarmNotifTimeOfDay(TimeOfDay value) : _value = value {
    if (_value.hour > (TimeOfDay.hoursPerDay - 1) || _value.hour < 0) {
      throw DomainException(
        type: DomainExceptionType.datetime,
        detail: 'hour value is incorrect',
      );
    }

    if (_value.minute > (TimeOfDay.minutesPerHour - 1) || _value.minute < 0) {
      throw DomainException(
        type: DomainExceptionType.datetime,
        detail: 'minute value is incorrect',
      );
    }
  }

  int get hour => _value.hour;

  int get minute => _value.minute;

  int get _minutes => (_value.hour * TimeOfDay.minutesPerHour) + _value.minute;

  @override
  String toString() {
    return _value.toString();
  }

  /// from number constructor
  AlarmNotifTimeOfDay.fromNumber(int hour, int minute)
      : this(TimeOfDay(hour: hour, minute: minute));

  /// compare to
  /// this > other = 1
  /// this < other = -1
  /// this == other = 0
  int compareTo(AlarmNotifTimeOfDay other) {
    return _minutes > other._minutes ? 1 : (_minutes < other._minutes ? -1 : 0);
  }

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is AlarmNotifTimeOfDay &&
          other.hour == hour &&
          other.minute == minute);

  @override
  int get hashCode => runtimeType.hashCode ^ _value.hashCode;
}
