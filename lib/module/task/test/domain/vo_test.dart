import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/vo/task_content.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';

void main() {
  group('Task entity test', () {
    test("Task start OK test", () {
      final sceneID = SceneID.generate();
      final scene = CreatedScene.create(
        id: sceneID,
        name: SceneName('name'),
        genre: Genre.hobby,
      );
      final start = StartedTask.start(
        id: TaskID.generate(),
        content: TaskContent('hello'),
        scene: scene,
        operationID: OperationID.generate(),
      );

      expect(start.sceneID, sceneID);
    });

    test("Task changeOperation OK test", () {
      final sceneID = SceneID.generate();
      final scene = CreatedScene.create(
        id: sceneID,
        name: SceneName('name'),
        genre: Genre.hobby,
      );
      final start = StartedTask.start(
        id: TaskID.generate(),
        content: TaskContent('hello'),
        scene: scene,
        operationID: OperationID.generate(),
      );

      final change = start.changeOperation(OperationID.generate());

      expect(change.operationID != start.operationID, isTrue);
    });

    test("Task discard and remove OK test", () {
      final sceneID = SceneID.generate();
      final scene = CreatedScene.create(
        id: sceneID,
        name: SceneName('name'),
        genre: Genre.hobby,
      );
      final start = StartedTask.start(
        id: TaskID.generate(),
        content: TaskContent('hello'),
        scene: scene,
        operationID: OperationID.generate(),
      );

      final discard = start.discard();

      expect(discard.isDiscarded, true);

      final remove = discard.remove();

      expect(remove, start);
    });
  });
}
