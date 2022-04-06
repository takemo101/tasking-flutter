import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/flow/domain/vo/operation_color.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_repository.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/vo/task_content.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';
import 'package:tasking/module/task/infrastructure/sqlite/task_repository.dart';

void main() async {
  final helper = SQLiteHelper(name: 'sqlite/task_repository.sqlite');

  File file = File(helper.currentDatabasePath());
  if (file.existsSync()) {
    file.deleteSync();
  }
  file.createSync();

  await helper.open();

  TaskSQLiteRepository repository = TaskSQLiteRepository(helper: helper);
  SceneSQLiteRepository sceneRepository = SceneSQLiteRepository(helper: helper);
  FlowSQLiteRepository flowRepository = FlowSQLiteRepository(helper: helper);

  group('TaskSQLiteRepository test', () {
    test("TaskSQLiteRepository store test", () async {
      //

      final scene = CreatedScene.create(
        id: SceneID.generate(),
        name: SceneName('scene'),
        genre: Genre.hobby,
      );

      await sceneRepository.store(scene);

      var flow = Flow.create(id: scene.id);
      flow = flow.addOperation(OperationDetail(
        name: OperationName('operat'),
        color: const OperationColor(1),
      ));

      await flowRepository.save(flow);

      final task = StartedTask.start(
        id: TaskID.generate(),
        content: TaskContent('store'),
        scene: scene,
        operationID: flow.defaultOperationID,
      );

      await repository.store(task);

      final findTask = await repository.findStartedByID(task.id);

      expect(findTask, isNotNull);
      if (findTask != null) {
        expect(findTask.id, task.id);
      }
    });

    test("TaskSQLiteRepository update test", () async {
      //

      final scene = CreatedScene.create(
        id: SceneID.generate(),
        name: SceneName('scene'),
        genre: Genre.hobby,
      );

      await sceneRepository.store(scene);

      var flow = Flow.create(id: scene.id);
      flow = flow.addOperation(OperationDetail(
        name: OperationName('operat'),
        color: const OperationColor(1),
      ));

      await flowRepository.save(flow);

      final task = StartedTask.start(
        id: TaskID.generate(),
        content: TaskContent('store'),
        scene: scene,
        operationID: flow.defaultOperationID,
      );

      await repository.store(task);

      final findTask = await repository.findStartedByID(task.id);

      expect(findTask, isNotNull);
      if (findTask != null) {
        final changeTask = findTask
            .changeOperation(flow.nextOperationID(findTask.operationID));

        await repository.update(changeTask);

        final findSecondTask = await repository.findStartedByID(changeTask.id);

        expect(findSecondTask, isNotNull);
        if (findSecondTask != null) {
          expect(findSecondTask.operationID,
              flow.nextOperationID(findTask.operationID));

          final discardTask = findSecondTask.discard();

          await repository.update(discardTask);

          final findDiscardTask =
              await repository.findDiscardedByID(discardTask.id);

          expect(findDiscardTask, isNotNull);
        }
      }
    });

    test("TaskSQLiteRepository remove test", () async {
      final scene = CreatedScene.create(
        id: SceneID.generate(),
        name: SceneName('scene'),
        genre: Genre.hobby,
      );

      await sceneRepository.store(scene);

      var flow = Flow.create(id: scene.id);
      flow = flow.addOperation(OperationDetail(
        name: OperationName('operat'),
        color: const OperationColor(1),
      ));

      await flowRepository.save(flow);

      final task = StartedTask.start(
        id: TaskID.generate(),
        content: TaskContent('store'),
        scene: scene,
        operationID: flow.defaultOperationID,
      ).discard();

      await repository.store(task);

      final findStartedTask = await repository.findStartedByID(task.id);

      expect(findStartedTask, isNull);

      final findDiscardTask = await repository.findDiscardedByID(task.id);

      expect(findDiscardTask, isNotNull);
      if (findDiscardTask != null) {
        await repository.remove(findDiscardTask.remove());

        final findSecondDiscardTask =
            await repository.findDiscardedByID(findDiscardTask.id);
        expect(findSecondDiscardTask, isNull);
      }
    });
  });
}
