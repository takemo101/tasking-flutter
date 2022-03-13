import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/vo/flow_order.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';

@immutable
class Operation {
  final OperationID id;
  final FlowOrder order;
  final OperationDetail detail;

  const Operation._({
    required this.id,
    required this.order,
    required this.detail,
  });

  /// create constructor
  Operation.create({
    required FlowOrder order,
    required OperationDetail detail,
  }) : this._(
          id: OperationID.generate(),
          order: order,
          detail: detail,
        );

  /// create initial data constructor
  Operation.initial()
      : this.create(
          order: FlowOrder.initial(),
          detail: OperationDetail.initial(),
        );

  /// reconstruct
  const Operation.reconstruct({
    required OperationID id,
    required FlowOrder order,
    required OperationDetail detail,
  }) : this._(
          id: id,
          order: order,
          detail: detail,
        );

  /// change flow order
  Operation changeOrder(FlowOrder order) {
    return Operation._(
      id: id,
      order: order,
      detail: detail,
    );
  }

  /// change operation detail
  Operation changeDetail(OperationDetail detail) {
    return Operation._(
      id: id,
      order: order,
      detail: detail,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is Operation && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}
