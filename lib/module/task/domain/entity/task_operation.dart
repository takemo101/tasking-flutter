import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

@immutable
class TaskOperation {
  final TaskID taskID;
  final OperationID operationID;

  const TaskOperation({
    required this.taskID,
    required this.operationID,
  });

  TaskOperation.fromStartedTask(StartedTask task)
      : this(
          taskID: task.id,
          operationID: task.operationID,
        );

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is TaskOperation &&
          other.taskID == taskID &&
          other.operationID == operationID);

  @override
  int get hashCode => runtimeType.hashCode;
}
