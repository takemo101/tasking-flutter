import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/task/domain/board.dart';
import 'package:tasking/module/task/domain/entity/pin.dart';
import 'package:tasking/module/task/domain/entity/task_operation.dart';
import 'package:tasking/module/task/domain/vo/board_order.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

/// board repository mapper class
class BoardRepositoryMapper {
  /// from board to operation map list
  List<Map<String, dynamic>> fromBoardToPinMapList(
    Board board,
  ) {
    List<Map<String, dynamic>> result = [];

    for (final pin in board.pins) {
      result.add(
        fromPinToMap(board.id, pin),
      );
    }

    return result;
  }

  /// from operation to map
  Map<String, dynamic> fromPinToMap(
    SceneID id,
    Pin pin,
  ) {
    return {
      'scene_id': id.value,
      'task_id': pin.taskID.value,
      'board_order': pin.order.value,
    };
  }

  /// from map to board aggregate
  Board fromMapToBoard(
    SceneID id,
    List<Map<String, dynamic>> pinMaps,
  ) {
    return Board.reconstruct(
      id: id,
      pins: pinMaps
          .map((op) => Pin(
                order: BoardOrder(op['board_order']),
                taskOperation: TaskOperation(
                  taskID: TaskID(op['task_id'].toString()),
                  operationID: OperationID(op['operation_id'].toString()),
                ),
              ))
          .toList(),
    );
  }
}
