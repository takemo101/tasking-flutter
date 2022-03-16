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

/// aggregate root class
@immutable
class Flow extends Scene {
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

  /// create constructor
  Flow.create({
    required SceneID id,
  }) : this._(
          id: id,
          operations: Operations.initial(),
        );

  /// reconstruct
  Flow.reconstruct({
    required SceneID id,
    required List<Operation> operations,
  }) : this._(
          id: id,
          operations: Operations(operations),
        );

  /// is unique operation name
  bool isUniqueOperationName(OperationName name, [OperationID? operationID]) {
    return operationID == null
        ? !_operations.hasByName(name)
        : !_operations.hasByNameExceptID(name, operationID);
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
  Flow addOperation(OperationDetail operationDetail) {
    return Flow._(
      id: id,
      operations: _operations.clone..add(operationDetail),
      events: domainEvents,
    );
  }

  /// change operation
  Flow changeOperation(
    OperationID operationID,
    OperationDetail operationDetail,
  ) {
    return Flow._(
      id: id,
      operations: _operations.clone
        ..changeByID(
          operationID,
          operationDetail,
        ),
      events: domainEvents,
    );
  }

  /// remove operation
  Flow removeOperation(
    OperationID operationID,
  ) {
    return Flow._(
      id: id,
      operations: _operations.clone..removeByID(operationID),
      events: domainEvents,
    );
  }

  /// clear
  Flow clear() {
    return Flow._(
      id: id,
      operations: Operations.empty(),
      events: domainEvents,
    );
  }

  /// reorder operation
  Flow reorderOperations(
    ReOrderOperationIDs operationIDs,
  ) {
    return Flow._(
      id: id,
      operations: _operations.clone..reorderByIDs(operationIDs),
      events: domainEvents,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is Flow && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}
