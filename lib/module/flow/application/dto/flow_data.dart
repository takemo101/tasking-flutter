import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/vo/flow_order.dart';

@immutable
class FlowData {
  final String id;
  final List<OperationData> operations;

  const FlowData({
    required this.id,
    required this.operations,
  });
}

@immutable
class OperationData {
  final String id;
  final String name;
  final int color;
  final int order;

  bool get isDefault => FlowOrder(order).isDefault;

  const OperationData({
    required this.id,
    required this.name,
    required this.color,
    required this.order,
  });

  @override
  bool operator ==(Object other) => other is OperationData && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
