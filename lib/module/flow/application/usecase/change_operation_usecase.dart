import 'package:meta/meta.dart';
import 'package:tasking/module/flow/application/exception.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/flow/domain/vo/operation_color.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';
import 'package:tasking/module/flow/domain/specification/unique_name_spec.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

/// create operation command dto
@immutable
class ChangeOperationCommand {
  final String id;
  final String operationID;
  final String name;
  final int color;

  const ChangeOperationCommand({
    required this.id,
    required this.operationID,
    required this.name,
    required this.color,
  });
}

/// change operation usecase
class ChangeOperationUseCase {
  final FlowRepository _repository;
  final Transaction _transaction;

  ChangeOperationUseCase({
    required FlowRepository repository,
    required Transaction transaction,
  })  : _repository = repository,
        _transaction = transaction;

  Future<AppResult<SceneID, ApplicationException>> execute(
      ChangeOperationCommand command) async {
    final operationDetail = OperationDetail(
      name: OperationName(command.name),
      color: OperationColor(command.color),
    );

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

        // unique name check
        if (!UniqueNameSpec(operationDetail, operationID).isSatisfiedBy(flow)) {
          throw NotUniqueOperationNameException();
        }

        await _repository.save(
          flow.changeOperation(operationID, operationDetail),
        );

        return flow.id;
      }),
    );
  }
}
