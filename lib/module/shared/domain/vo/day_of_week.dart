import 'package:tasking/module/shared/domain/exception.dart';

enum DayOfWeek {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}

/// day of week index extension
extension DayOfWeekIndex on DayOfWeek {
  /// create from index number
  static DayOfWeek fromIndex(int index) {
    return DayOfWeek.values.firstWhere(
      (gen) => gen.index == index,
      orElse: () => DayOfWeek.sunday,
    );
  }
}

/// day of week datetime weekday extension
extension DayOfWeekday on DayOfWeek {
  /// create from datetime weekday
  static DayOfWeek fromWeekday(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return DayOfWeek.sunday;
      case DateTime.monday:
        return DayOfWeek.monday;
      case DateTime.tuesday:
        return DayOfWeek.tuesday;
      case DateTime.wednesday:
        return DayOfWeek.wednesday;
      case DateTime.thursday:
        return DayOfWeek.thursday;
      case DateTime.friday:
        return DayOfWeek.friday;
      case DateTime.saturday:
        return DayOfWeek.saturday;
    }
    throw DomainException(
      type: DomainExceptionType.datetime,
      detail: 'weekday does not match!',
    );
  }

  /// get datetime weekday number
  int get weekday {
    switch (this) {
      case DayOfWeek.sunday:
        return DateTime.sunday;
      case DayOfWeek.monday:
        return DateTime.monday;
      case DayOfWeek.tuesday:
        return DateTime.tuesday;
      case DayOfWeek.wednesday:
        return DateTime.wednesday;
      case DayOfWeek.thursday:
        return DateTime.thursday;
      case DayOfWeek.friday:
        return DateTime.friday;
      case DayOfWeek.saturday:
        return DateTime.saturday;
    }
  }
}
