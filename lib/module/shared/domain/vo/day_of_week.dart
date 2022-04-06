enum DayOfWeek {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}

// day of week index extension
extension DayOfWeekIndex on DayOfWeek {
  /// create from index number
  static DayOfWeek fromIndex(int index) {
    return DayOfWeek.values.firstWhere(
      (gen) => gen.index == index,
      orElse: () => DayOfWeek.sunday,
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
