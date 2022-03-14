import 'package:tasking/module/shared/domain/exception.dart';

abstract class UniqueParts<T> {
  final List<T> value = <T>[];

  UniqueParts(List<T> list) {
    for (final part in list) {
      if (value.contains(part)) {
        throw DomainException(
          type: DomainExceptionType.duplicate,
          detail: 'part is duplicated!',
        );
      }
      value.add(part);
    }
  }

  bool isSameLength(int length) {
    return value.length == length;
  }
}

abstract class Parts<T, P extends UniqueParts> extends UniqueParts<T> {
  Parts(List<T> list) : super(list);

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is P && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;
}
