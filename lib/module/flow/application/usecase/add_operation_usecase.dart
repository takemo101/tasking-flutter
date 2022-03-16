import 'package:meta/meta.dart';
import 'package:tasking/module/flow/application/exception.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/flow/domain/vo/operation_color.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';
import 'package:tasking/module/flow/domain/specification/unique_name_spec.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

/// add operation command dto
@immutable
class AddOperationCommand {
  final String id;
  final String name;
  final int color;

  const AddOperationCommand({
    required this.id,
    required this.name,
    required this.color,
  });
}

/// add operation usecase
class AddOperationUseCase {
  final FlowRepository _repository;
  final Transaction _transaction;

  AddOperationUseCase({
    required FlowRepository repository,
    required Transaction transaction,
  })  : _repository = repository,
        _transaction = transaction;

  Future<void> execute(AddOperationCommand command) async {
    final operationDetail = OperationDetail(
      name: OperationName(command.name),
      color: OperationColor(command.color),
    );

    await _transaction.transaction(() async {
      final flow = await _repository.findByID(SceneID(command.id));

      if (flow == null) {
        throw NotFoundException(command.id, name: 'flow');
      }

      // unique name check
      if (!UniqueNameSpec(flow).isSatisfiedBy(operationDetail)) {
        throw NotUniqueOperationNameException();
      }

      // limit check
      if (flow.isLimitSizeOperations) {
        throw LimitSizeOperationsException();
      }

      await _repository.save(flow.addOperation(operationDetail));
    });
  }
}
