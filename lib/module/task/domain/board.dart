import 'package:meta/meta.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/task/domain/collection/pins.dart';
import 'package:tasking/module/task/domain/entity/pin.dart';
import 'package:tasking/module/task/domain/entity/task_operation.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';
import 'package:tasking/module/task/domain/vo/tidy_operation_ids.dart';

/// aggregate root class
@immutable
class Board extends TaskTypeScene {
  final Pins _pins;

  /// private constructor
  const Board._({
    required SceneID id,
    required Pins pins,
    List<Event> events = const <Event>[],
  })  : _pins = pins,
        super(
          id: id,
          events: events,
        );

  /// reconstruct
  Board.reconstruct({
    required SceneID id,
    required List<Pin> pins,
  }) : this._(
          id: id,
          pins: Pins(pins),
        );

  Board.empty({
    required SceneID id,
  }) : this._(
          id: id,
          pins: Pins.empty(),
        );

  /// get operation list
  List<Pin> get pins => _pins.pins;

  /// is unique task id
  bool isUniqueTaskID(TaskID taskID) {
    return !_pins.hasByTaskID(taskID);
  }

  Board addPinByStartedTask(StartedTask task) {
    if (task.sceneID != id) {
      throw DomainException(
        type: DomainExceptionType.notMatch,
        detail: 'not match [id = ${task.sceneID}] board!',
      );
    }

    return Board._(
      id: id,
      pins: _pins.clone..add(TaskOperation.fromStartedTask(task)),
      events: domainEvents,
    );
  }

  Board removePinByDiscardedTask(DiscardedTask task) {
    if (task.sceneID != id) {
      throw DomainException(
        type: DomainExceptionType.notMatch,
        detail: 'not match [id = ${task.sceneID}] board!',
      );
    }

    return Board._(
      id: id,
      pins: _pins.clone..removeByTaskID(task.id),
      events: domainEvents,
    );
  }

  Board tidyPin(TidyOperationIDs operationIDs) {
    return Board._(
      id: id,
      pins: _pins.clone..tidyByOperationIDs(operationIDs),
      events: domainEvents,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is Board && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}
