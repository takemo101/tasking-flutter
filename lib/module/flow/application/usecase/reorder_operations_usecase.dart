import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/flow/domain/vo/reorder_operation_ids.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

/// oreder operation command dto
@immutable
class ReOrderOperationCommand {
  final String id;
  final List<String> operationIDs;

  const ReOrderOperationCommand({
    required this.id,
    required this.operationIDs,
  });
}

/// reorder operations usecase
class ReOrderOperationsUseCase {
  final FlowRepository _repository;
  final Transaction _transaction;

  ReOrderOperationsUseCase({
    required FlowRepository repository,
    required Transaction transaction,
  })  : _repository = repository,
        _transaction = transaction;

  Future<void> execute(ReOrderOperationCommand command) async {
    await _transaction.transaction(() async {
      final flow = await _repository.findByID(SceneID(command.id));

      if (flow == null) {
        throw NotFoundException(command.id, name: 'flow');
      }

      final reOrderOperationIDs =
          ReOrderOperationIDs.fromStringList(command.operationIDs);

      await _repository.update(
        flow.reorderOperations(reOrderOperationIDs),
      );
    });
  }
}
