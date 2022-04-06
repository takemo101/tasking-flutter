import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/vo/task_content.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

/// start default task factory class
class StartDefaultTask {
  final SceneRepository _sceneRepository;
  final Flow _flow;

  StartDefaultTask({
    required SceneRepository sceneRepository,
    required Flow flow,
  })  : _sceneRepository = sceneRepository,
        _flow = flow;

  /// create default start task
  Future<StartedTask> start(TaskContent content) async {
    final scene = await _sceneRepository.findByID(_flow.id);

    if (scene == null) {
      throw DomainException(
        type: DomainExceptionType.notFound,
        detail: 'not found [id = ${_flow.id.value}] scene!',
      );
    }

    return StartedTask.start(
      id: TaskID.generate(),
      content: content,
      scene: scene,
      operationID: _flow.defaultOperationID,
    );
  }
}
