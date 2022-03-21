import 'package:meta/meta.dart';
import 'package:tasking/module/flow/application/exception.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/flow/domain/specification/exists_task_operation_spec.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/task/domain/task_repository.dart';

/// remove operation command dto
@immutable
class RemoveOperationCommand {
  final String id;
  final String operationID;

  const RemoveOperationCommand({
    required this.id,
    required this.operationID,
  });
}

/// remove operation usecase
class RemoveOperationUseCase {
  final FlowRepository _repository;
  final ExistsTaskOperationSpec _spec;
  final Transaction _transaction;

  RemoveOperationUseCase({
    required FlowRepository repository,
    required TaskRepository taskRepository,
    required Transaction transaction,
  })  : _repository = repository,
        _spec = ExistsTaskOperationSpec(taskRepository),
        _transaction = transaction;

  Future<AppResult<SceneID, ApplicationException>> execute(
      RemoveOperationCommand command) async {
    return await AppResult.monitor(
      () async => await _transaction.transaction(() async {
        final flow = await _repository.findByID(SceneID(command.id));

        if (flow == null) {
          throw NotFoundException(command.id);
        }

        final operationID = OperationID(command.operationID);

        if (!flow.isAssignableOperation(operationID)) {
          throw NotFoundException(command.id);
        }

        if (!await _spec.isSatisfiedBy(operationID)) {
          throw ExistsTaskOperationException();
        }

        await _repository.save(
          flow.removeOperation(operationID),
        );

        return flow.id;
      }),
    );
  }
}
