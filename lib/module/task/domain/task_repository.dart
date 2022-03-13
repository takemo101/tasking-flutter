import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

abstract class TaskRepository {
  Future<StartedTask?> findStartedByID(TaskID id);
  Future<DiscardedTask?> findDiscardedByID(TaskID id);
  Future<bool> existsByOperationID(OperationID id);
  Future<void> store(CreatedTask task);
  Future<void> update(CreatedTask task);
  Future<void> remove(RemovedTask task);
}
