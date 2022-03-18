import 'package:flutter/foundation.dart';
import 'package:tasking/module/flow/application/dto/flow_data.dart';
import 'package:tasking/module/flow/application/query/flow_query.dart';
import 'package:tasking/module/flow/application/usecase/add_operation_usecase.dart';
import 'package:tasking/module/flow/application/usecase/change_operation_usecase.dart';
import 'package:tasking/module/flow/application/usecase/flow_detail_usecase.dart';
import 'package:tasking/module/flow/application/usecase/remove_operation_usecase.dart';
import 'package:tasking/module/flow/application/usecase/reorder_operations_usecase.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/task/domain/task_repository.dart';

class FlowNotifier extends ChangeNotifier {
  final AddOperationUseCase _addUseCase;
  final ChangeOperationUseCase _changeUseCase;
  final FlowDetailUseCase _detailUseCase;
  final RemoveOperationUseCase _removeUseCase;
  final ReOrderOperationsUseCase _reorderUseCase;

  final String _id;

  FlowData? _detail;

  FlowData? get detail => _detail;

  FlowNotifier(
    String id, {
    required FlowRepository repository,
    required TaskRepository taskRepository,
    required FlowQuery query,
    required Transaction transaction,
  })  : _id = id,
        _addUseCase = AddOperationUseCase(
          repository: repository,
          transaction: transaction,
        ),
        _changeUseCase = ChangeOperationUseCase(
          repository: repository,
          transaction: transaction,
        ),
        _detailUseCase = FlowDetailUseCase(query: query),
        _removeUseCase = RemoveOperationUseCase(
          repository: repository,
          taskRepository: taskRepository,
          transaction: transaction,
        ),
        _reorderUseCase = ReOrderOperationsUseCase(
          repository: repository,
          transaction: transaction,
        );

  Future<AppResult<SceneID, ApplicationException>> addOpertion({
    required String name,
    required int color,
  }) async {
    final result = await _addUseCase.execute(
      AddOperationCommand(
        id: _id,
        name: name,
        color: color,
      ),
    );

    if (result.isSuccess) {
      detailUpdate();
    }

    return result;
  }

  Future<AppResult<SceneID, ApplicationException>> changeOperation({
    required String operationID,
    required String name,
    required int color,
  }) async {
    final result = await _changeUseCase.execute(
      ChangeOperationCommand(
        id: _id,
        operationID: operationID,
        name: name,
        color: color,
      ),
    );

    if (result.isSuccess) {
      detailUpdate();
    }

    return result;
  }

  Future<AppResult<SceneID, ApplicationException>> removeOperation({
    required String id,
    required String operationID,
  }) async {
    final result = await _removeUseCase.execute(
      RemoveOperationCommand(
        id: _id,
        operationID: operationID,
      ),
    );

    if (result.isSuccess) {
      detailUpdate();
    }

    return result;
  }

  Future<AppResult<SceneID, ApplicationException>> reorderOperation({
    required String id,
    required List<String> operationIDs,
  }) async {
    final result = await _reorderUseCase.execute(
      ReOrderOperationsCommand(
        id: id,
        operationIDs: operationIDs,
      ),
    );

    if (result.isSuccess) {
      detailUpdate();
    }

    return result;
  }

  void detailUpdate() {
    _detailUseCase.execute(_id).then((result) {
      if (result.isSuccess) {
        _detail = result.result;
        notifyListeners();
      }
    });
  }
}
