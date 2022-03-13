import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/task/domain/task.dart';

/// change task to next operation service class
class ChangeToNextOperation {
  final FlowRepository _repository;

  ChangeToNextOperation(this._repository);

  /// create start task
  Future<StartedTask> changeToNextOperation(StartedTask task) async {
    final flow = await _repository.findByID(task.sceneID);

    // not found
    if (flow == null) {
      throw DomainException(
        type: DomainExceptionType.notFound,
        detail: 'not found [scene id = ${task.sceneID}] flow!',
      );
    }

    return task.changeOperation(
      flow.nextOperationID(task.operationID),
    );
  }
}
