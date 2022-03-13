import 'package:meta/meta.dart';

@immutable
class OperationColor {
  final int value;

  const OperationColor(int color) : value = color & 0xFFFFFFFF;

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is OperationColor && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;
}
