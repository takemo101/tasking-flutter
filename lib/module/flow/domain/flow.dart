import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/collection/operations.dart';
import 'package:tasking/module/flow/domain/entity/operation.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';
import 'package:tasking/module/flow/domain/vo/reorder_operation_ids.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/domain/event.dart';

/// aggregate root base class
abstract class Flow extends Scene {
  final Operations _operations;

  /// private constructor
  const Flow._({
    required SceneID id,
    required Operations operations,
    List<Event> events = const <Event>[],
  })  : _operations = operations,
        super(
          id: id,
          events: events,
        );

  /// get operation list
  List<Operation> get operations => _operations.operations;

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is Flow && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}

/// created task class
@immutable
class CreatedFlow extends Flow {
  /// private constructor
  const CreatedFlow._({
    required SceneID id,
    required Operations operations,
    List<Event> events = const <Event>[],
  }) : super._(
          id: id,
          operations: operations,
          events: events,
        );

  /// create constructor
  CreatedFlow.create({
    required SceneID id,
  }) : super._(
          id: id,
          operations: Operations.initial(),
        );

  /// reconstruct
  CreatedFlow.reconstruct({
    required SceneID id,
    required List<Operation> operations,
  }) : this._(
          id: id,
          operations: Operations(operations),
        );

  /// is unique operation name
  bool isUniqueOperationName(OperationName name) {
    return !_operations.hasByName(name);
  }

  /// is assignable operation name
  bool isAssignableOperation(OperationID id) {
    return _operations.hasByID(id);
  }

  /// get next operation id
  OperationID nextOperationID(OperationID id) {
    return _operations.nextByID(id).id;
  }

  /// get default operation id
  OperationID get defaultOperationID => _operations.defaultOperation().id;

  /// add operation
  CreatedFlow addOperation(OperationDetail operationDetail) {
    final ops = _operations.clone;

    ops.add(operationDetail);

    return CreatedFlow._(
      id: id,
      operations: ops,
      events: domainEvents,
    );
  }

  /// change operation
  CreatedFlow changeOperation(
    OperationID operationID,
    OperationDetail operationDetail,
  ) {
    final ops = _operations.clone;
    ops.changeByID(operationID, operationDetail);

    return CreatedFlow._(
      id: id,
      operations: ops,
      events: domainEvents,
    );
  }

  /// remove operation
  CreatedFlow removeOperation(
    OperationID operationID,
  ) {
    final ops = _operations.clone;
    ops.removeByID(operationID);

    return CreatedFlow._(
      id: id,
      operations: ops,
      events: domainEvents,
    );
  }

  /// clear
  CreatedFlow clear() {
    return CreatedFlow._(
      id: id,
      operations: Operations.empty(),
      events: domainEvents,
    );
  }

  /// reorder operation
  CreatedFlow reorderOperations(
    ReOrderOperationIDs operationIDs,
  ) {
    final ops = _operations.clone;
    ops.reorderByIDs(operationIDs);

    return CreatedFlow._(
      id: id,
      operations: ops,
      events: domainEvents,
    );
  }
}
