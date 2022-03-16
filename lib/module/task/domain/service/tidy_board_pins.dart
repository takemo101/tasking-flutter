import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/task/domain/board.dart';
import 'package:tasking/module/task/domain/vo/tidy_operation_ids.dart';

/// tidy board task pin service class
class TidyBoardPins {
  final FlowRepository _repository;

  TidyBoardPins(this._repository);

  /// create start task
  Future<Board> tidy(Board board) async {
    final flow = await _repository.findByID(board.id);

    // not found
    if (flow == null) {
      throw DomainException(
        type: DomainExceptionType.notFound,
        detail: 'not found [scene id = ${board.id}] flow!',
      );
    }

    final operationIDs =
        TidyOperationIDs(flow.operations.map((op) => op.id).toList());

    return board.tidyPin(operationIDs);
  }
}
