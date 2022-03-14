import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/task/domain/entity/task_operation.dart';
import 'package:tasking/module/task/domain/vo/board_order.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

@immutable
class Pin {
  final BoardOrder order;
  final TaskOperation _taskOperation;

  TaskID get taskID => _taskOperation.taskID;

  const Pin({
    required this.order,
    required TaskOperation taskOperation,
  }) : _taskOperation = taskOperation;

  bool equalOperationID(OperationID operationID) {
    return _taskOperation.operationID == operationID;
  }

  Pin changeOrder(BoardOrder order) {
    return Pin(
      order: order,
      taskOperation: _taskOperation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is Pin && other.taskID == taskID && other.order == order);

  @override
  int get hashCode => runtimeType.hashCode;
}
