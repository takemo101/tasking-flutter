import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/task/domain/entity/pin.dart';
import 'package:tasking/module/task/domain/entity/task_operation.dart';
import 'package:tasking/module/task/domain/vo/board_order.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';
import 'package:tasking/module/task/domain/vo/tidy_operation_ids.dart';

/// pin collection mutable class
class Pins {
  List<Pin> _pins;

  Pins(
    List<Pin> pins,
  ) : _pins = pins {
    _pins.sort((a, b) => a.order.compareTo(b.order));
  }

  /// create empty data constructor
  Pins.empty() : this(<Pin>[]);

  /// has by task id
  bool hasByTaskID(TaskID taskID) {
    return _pins.indexWhere((pn) => pn.taskID == taskID) != -1;
  }

  /// add operation
  void add(TaskOperation taskOperation) {
    // duplicate check
    if (hasByTaskID(taskOperation.taskID)) {
      throw DomainException(
        type: DomainExceptionType.duplicate,
        detail: 'task id is duplicated!',
      );
    }

    _pins.add(Pin(
      order: _pins.isEmpty ? BoardOrder.initial() : _lastOrder.nextOrder(),
      taskOperation: taskOperation,
    ));
  }

  /// remove operation by id
  void removeByTaskID(TaskID taskID) {
    final index = _pins.indexWhere((pn) => pn.taskID == taskID);

    if (index != -1) {
      _pins.removeAt(index);

      var order = BoardOrder.initial();

      /// reorder
      _pins.asMap().forEach((int i, Pin pin) {
        _pins[i] = pin.changeOrder(order);
        order = order.nextOrder();
      });

      return;
    }

    throw DomainException(
      type: DomainExceptionType.notFound,
      detail: 'not found [task id = ${taskID.value}] pin!',
    );
  }

  /// tidy pins by operation id list
  void tidyByOperationIDs(TidyOperationIDs operationIDs) {
    List<Pin> tidyPins = <Pin>[];
    BoardOrder order = BoardOrder.initial();

    // reorder
    for (final operationID in operationIDs.value) {
      final operationPins =
          _pins.where((pn) => pn.equalOperationID(operationID));

      for (final pn in operationPins) {
        tidyPins.add(pn.changeOrder(order));
        order = order.nextOrder();
      }
    }

    _pins = tidyPins;
  }

  /// get last board order
  BoardOrder get _lastOrder {
    var order = BoardOrder.initial();

    for (final pn in _pins) {
      if (order.compareTo(pn.order) == -1) {
        order = pn.order;
      }
    }
    return order;
  }

  /// get pin list
  List<Pin> get pins => [..._pins];

  /// get clone
  Pins get clone => Pins(pins);
}
