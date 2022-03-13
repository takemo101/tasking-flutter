import 'package:meta/meta.dart';

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

  const OperationData({
    required this.id,
    required this.name,
    required this.color,
    required this.order,
  });
}
