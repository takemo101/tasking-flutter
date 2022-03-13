import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/vo/operation_color.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';

@immutable
class OperationDetail {
  final OperationName name;
  final OperationColor color;

  const OperationDetail({
    required this.name,
    required this.color,
  });

  /// create initial operation detail constructor
  OperationDetail.initial()
      : this(
          name: OperationName('新規'),
          color: const OperationColor(0),
        );

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is OperationDetail && other.name == name) && other.color == color;

  @override
  int get hashCode => runtimeType.hashCode;
}
