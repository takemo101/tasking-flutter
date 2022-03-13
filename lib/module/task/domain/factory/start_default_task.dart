import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/vo/task_content.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

/// start default task factory class
class StartDefaultTask {
  final CreatedFlow _flow;

  StartDefaultTask(this._flow);

  /// create default start task
  StartedTask start(TaskContent content) {
    return StartedTask.start(
      id: TaskID.generate(),
      content: content,
      sceneID: _flow.id,
      operationID: _flow.defaultOperationID,
    );
  }
}
