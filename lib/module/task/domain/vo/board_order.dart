import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/exception.dart';

@immutable
class BoardOrder {
  final int value;

  /// constructor
  BoardOrder(int order) : value = order {
    if (order < 0) {
      throw DomainException(
        type: DomainExceptionType.number,
        detail: 'order number is a negative number!',
      );
    }
  }

  /// create initial board order constructor
  BoardOrder.initial() : this(0);

  /// create next board order
  BoardOrder nextOrder() {
    return BoardOrder(value + 1);
  }

  /// compare to
  /// this > other = 1
  /// this < other = -1
  /// this == other = 0
  int compareTo(BoardOrder other) {
    return value > other.value ? 1 : (value < other.value ? -1 : 0);
  }

  /// is default order?
  bool get isDefault => value == 0;

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is BoardOrder && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;
}
