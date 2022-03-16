import 'package:tasking/module/flow/domain/entity/operation.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/vo/flow_order.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';
import 'package:tasking/module/flow/domain/vo/reorder_operation_ids.dart';
import 'package:tasking/module/shared/domain/exception.dart';

/// operation collection mutable class
class Operations {
  List<Operation> _operations;

  Operations(
    List<Operation> operations,
  ) : _operations = operations {
    _operations.sort((a, b) => a.order.compareTo(b.order));
  }

  /// create initial data constructor
  Operations.initial() : this(<Operation>[Operation.initial()]);

  /// create empty data constructor
  Operations.empty() : this(<Operation>[]);

  /// has by operation name
  bool hasByName(OperationName name) {
    return _operations.indexWhere((op) => op.detail.name == name) != -1;
  }

  /// has by operation name
  bool hasByNameExceptID(OperationName name, OperationID id) {
    return _operations
            .indexWhere((op) => op.id != id && op.detail.name == name) !=
        -1;
  }

  /// has by operation id
  bool hasByID(OperationID id) {
    return _operations.indexWhere((op) => op.id == id) != -1;
  }

  /// next operation by id
  Operation nextByID(OperationID id) {
    final index = _operations.indexWhere((op) => op.id == id);

    if (index == -1) {
      throw DomainException(
        type: DomainExceptionType.notFound,
        detail: 'not found [id = ${id.value}] operation!',
      );
    }

    return _operations[_operations.length - 1 <= index ? 0 : index + 1];
  }

  Operation defaultOperation() {
    final index = _operations.indexWhere((op) => op.order.isDefault);

    // replace operation
    if (index != -1) {
      return _operations[index];
    }

    throw DomainException(
      type: DomainExceptionType.notFound,
      detail: 'not found default operation!',
    );
  }

  /// add operation
  void add(OperationDetail detail) {
    // duplicate check
    if (hasByName(detail.name)) {
      throw DomainException(
        type: DomainExceptionType.duplicate,
        detail: 'name is duplicated!',
      );
    }

    _operations.add(Operation.create(
      order: _lastOrder.nextOrder(),
      detail: detail,
    ));
  }

  /// change operation by id
  void changeByID(OperationID id, OperationDetail detail) {
    final index = _operations.indexWhere((op) => op.id == id);

    // replace operation
    if (index != -1) {
      _operations[index] = _operations[index].changeDetail(detail);
      return;
    }

    throw DomainException(
      type: DomainExceptionType.notFound,
      detail: 'not found [id = ${id.value}] operation!',
    );
  }

  /// remove operation by id
  void removeByID(OperationID id) {
    final index = _operations.indexWhere((op) => op.id == id);

    if (index != -1) {
      if (_operations[index].order.isDefault) {
        throw DomainException(
          type: DomainExceptionType.specification,
          detail: 'default operation cannot be removed',
        );
      }

      _operations.removeAt(index);

      var order = FlowOrder.initial();

      /// reorder
      _operations.asMap().forEach((int i, Operation op) {
        _operations[i] = op.changeOrder(order);
        order = order.nextOrder();
      });

      return;
    }

    throw DomainException(
      type: DomainExceptionType.notFound,
      detail: 'not found [id = ${id.value}] operation!',
    );
  }

  /// reorder operations by id list
  void reorderByIDs(ReOrderOperationIDs operationIDs) {
    if (!operationIDs.isSameLength(_operations.length)) {
      throw DomainException(
        type: DomainExceptionType.length,
        detail: 'id length is different',
      );
    }

    List<Operation> reorderOperations = <Operation>[];
    FlowOrder order = FlowOrder.initial();

    // reorder
    for (final id in operationIDs.value) {
      final operation = _operations
          .cast<Operation?>()
          .firstWhere((op) => op == null ? false : op.id == id);

      if (operation != null) {
        reorderOperations.add(operation.changeOrder(order));
        order = order.nextOrder();
      } else {
        throw DomainException(
          type: DomainExceptionType.notFound,
          detail: 'not found [id = ${id.value}] operation!',
        );
      }
    }

    _operations = reorderOperations;
  }

  /// get last flow order
  FlowOrder get _lastOrder {
    return _operations.last.order;
  }

  /// get operations list
  List<Operation> get operations => [..._operations];

  /// get clone
  Operations get clone => Operations(operations);
}
