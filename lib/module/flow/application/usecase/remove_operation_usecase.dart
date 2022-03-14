import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

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
  final Transaction _transaction;

  RemoveOperationUseCase({
    required FlowRepository repository,
    required Transaction transaction,
  })  : _repository = repository,
        _transaction = transaction;

  Future<void> execute(RemoveOperationCommand command) async {
    await _transaction.transaction(() async {
      final flow = await _repository.findByID(SceneID(command.id));

      if (flow == null) {
        throw NotFoundException(command.id, name: 'flow');
      }

      final operationID = OperationID(command.operationID);

      if (!flow.isAssignableOperation(operationID)) {
        throw NotFoundException(command.id, name: 'operation');
      }

      await _repository.save(
        flow.removeOperation(operationID),
      );
    });
  }
}
