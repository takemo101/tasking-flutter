import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/task/domain/board_repository.dart';
import 'package:tasking/module/task/domain/service/tidy_board_pins.dart';

/// create scene usecase
class TidyTasksUseCase {
  final TidyBoardPins _service;
  final BoardRepository _boardRepository;
  final Transaction _transaction;

  TidyTasksUseCase({
    required FlowRepository flowRepository,
    required BoardRepository boardRepository,
    required Transaction transaction,
  })  : _service = TidyBoardPins(flowRepository),
        _boardRepository = boardRepository,
        _transaction = transaction;

  Future<AppResult<SceneID, ApplicationException>> execute(
      String sceneID) async {
    return await AppResult.listen(() async {
      return await _transaction.transaction(() async {
        final board = await _boardRepository.findByID(SceneID(sceneID));

        try {
          await _boardRepository.save(
            await _service.tidy(board),
          );
        } on DomainException catch (e) {
          if (e.hasType(DomainExceptionType.notFound)) {
            throw NotFoundException(sceneID);
          } else {
            rethrow;
          }
        }

        return board.id;
      });
    });
  }
}
