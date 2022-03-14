import 'package:flutter/foundation.dart';
import 'package:tasking/module/flow/application/dto/flow_data.dart';
import 'package:tasking/module/flow/application/query/flow_query.dart';
import 'package:tasking/module/flow/application/usecase/add_operation_usecase.dart';
import 'package:tasking/module/flow/application/usecase/change_operation_usecase.dart';
import 'package:tasking/module/flow/application/usecase/flow_detail_usecase.dart';
import 'package:tasking/module/flow/application/usecase/remove_operation_usecase.dart';
import 'package:tasking/module/flow/application/usecase/reorder_operations_usecase.dart';
import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

class FlowNotifier extends ChangeNotifier {
  final AddOperationUseCase _addUseCase;
  final ChangeOperationUseCase _changeUseCase;
  final FlowDetailUseCase _detailUseCase;
  final RemoveOperationUseCase _removeUseCase;
  final ReOrderOperationsUseCase _reorderUseCase;

  FlowData? _detail;

  FlowData? get detail => _detail;

  FlowNotifier({
    required FlowRepository repository,
    required FlowQuery query,
    required Transaction transaction,
  })  : _addUseCase = AddOperationUseCase(
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
          transaction: transaction,
        ),
        _reorderUseCase = ReOrderOperationsUseCase(
          repository: repository,
          transaction: transaction,
        );

  void addOpertion({
    required String id,
    required String name,
    required int color,
  }) async {
    await _addUseCase.execute(
      AddOperationCommand(
        id: id,
        name: name,
        color: color,
      ),
    );

    detailUpdate(id);
  }

  void changeOperation({
    required String id,
    required String operationID,
    required String name,
    required int color,
  }) async {
    await _changeUseCase.execute(
      ChangeOperationCommand(
        id: id,
        operationID: operationID,
        name: name,
        color: color,
      ),
    );

    detailUpdate(id);
  }

  void removeOperation({
    required String id,
    required String operationID,
  }) async {
    await _removeUseCase.execute(
      RemoveOperationCommand(
        id: id,
        operationID: operationID,
      ),
    );

    detailUpdate(id);
  }

  void reorderOperation({
    required String id,
    required List<String> operationIDs,
  }) async {
    await _reorderUseCase.execute(
      ReOrderOperationsCommand(
        id: id,
        operationIDs: operationIDs,
      ),
    );

    detailUpdate(id);
  }

  void detailUpdate(String id) {
    _detailUseCase.execute(id).then((detail) {
      _detail = detail;
      notifyListeners();
    });
  }
}
