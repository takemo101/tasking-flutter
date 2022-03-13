import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/shared/domain/exception.dart';

@immutable
class ReOrderOperationIDs {
  final List<OperationID> value = <OperationID>[];

  ReOrderOperationIDs(List<OperationID> list) {
    for (final id in list) {
      if (value.contains(id)) {
        throw DomainException(
          type: DomainExceptionType.duplicate,
          detail: 'operation id is duplicated!',
        );
      }
      value.add(id);
    }
  }

  ReOrderOperationIDs.fromStringList(List<String> strings)
      : this(
          strings.map<OperationID>((s) => OperationID(s)).toList(),
        );

  bool isSameLength(int length) {
    return value.length == length;
  }

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is ReOrderOperationIDs && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;
}
