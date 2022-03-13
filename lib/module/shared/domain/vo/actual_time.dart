import 'package:tasking/module/shared/domain/exception.dart';

abstract class ActualDateTime {
  final DateTime value;

  ActualDateTime(this.value) {
    var now = DateTime.now();

    if (value.isAfter(now)) {
      throw DomainException(
        type: DomainExceptionType.datetime,
        detail: 'time is future!',
      );
    }
  }

  @override
  String toString() {
    return value.toString();
  }

  /// now datetime constructor
  ActualDateTime.now() : this(DateTime.now());

  /// from string constructor
  ActualDateTime.fromString(String string) : this(DateTime.parse(string));
}

abstract class ActualTime<T extends ActualDateTime> extends ActualDateTime {
  ActualTime(DateTime value) : super(value);
  ActualTime.now() : super.now();
  ActualTime.fromString(String string) : super.fromString(string);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is T && other.value.isAtSameMomentAs(value));

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;
}
