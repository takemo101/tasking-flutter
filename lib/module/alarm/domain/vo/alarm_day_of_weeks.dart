import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';

@immutable
class AlarmDayOfWeeks {
  final List<DayOfWeek> value;

  /// constructor
  AlarmDayOfWeeks(List<DayOfWeek> dayOfWeeks)
      : value = dayOfWeeks.toSet().toList() {
    if (value.isEmpty) {
      throw DomainException(
        type: DomainExceptionType.size,
        detail: 'list size of the alarm time is too large!',
        jp: '曜日をひとつ以上選択してください！',
      );
    }
  }

  @override
  String toString() {
    return value.toString();
  }

  AlarmDayOfWeeks.empty() : this([]);

  /// from index list constructor
  AlarmDayOfWeeks.fromIndexes(List<int> indexes)
      : this(indexes.map((index) => DayOfWeekIndex.fromIndex(index)).toList());

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is AlarmDayOfWeeks && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;
}
