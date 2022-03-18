import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/flow/application/subscriber/create_scene_flow_subscriber.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/vo/operation_color.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_repository.dart';
import 'package:tasking/module/scene/application/subscriber/change_task_operation_scene_subscriber.dart';
import 'package:tasking/module/scene/application/subscriber/resume_task_scene_subscriber.dart';
import 'package:tasking/module/scene/application/subscriber/start_task_scene_subscriber.dart';
import 'package:tasking/module/scene/application/usecase/create_scene_usecase.dart';
import 'package:tasking/module/scene/domain/event/scene_event.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/shared/infrastructure/event.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/transaction.dart';
import 'package:tasking/module/task/application/usecase/change_task_operation_usecase.dart';
import 'package:tasking/module/task/application/usecase/discard_task_usecase.dart';
import 'package:tasking/module/task/application/usecase/remove_task_usecase.dart';
import 'package:tasking/module/task/application/usecase/resume_task_usecase.dart';
import 'package:tasking/module/task/application/usecase/start_task_usecase.dart';
import 'package:tasking/module/task/domain/event/task_event.dart';
import 'package:tasking/module/task/infrastructure/sqlite/board_repository.dart';
import 'package:tasking/module/task/infrastructure/sqlite/task_query.dart';
import 'package:tasking/module/task/infrastructure/sqlite/task_repository.dart';

void main() async {
  final helper = SQLiteHelper();

  File file = File(helper.currentDatabasePath());
  file.deleteSync();
  file.createSync();

  await helper.open();

  SceneSQLiteRepository sceneRepository = SceneSQLiteRepository(helper: helper);
  FlowSQLiteRepository flowRepository = FlowSQLiteRepository(helper: helper);
  BoardSQLiteRepository boardRepository = BoardSQLiteRepository(helper: helper);

  TaskSQLiteQuery query = TaskSQLiteQuery(helper: helper);
  TaskSQLiteRepository repository = TaskSQLiteRepository(helper: helper);
  SQLiteTransaction transaction = SQLiteTransaction(helper: helper);

  SyncDomainEventBus bus = SyncDomainEventBus();

  bus.subscribe<CreateSceneEvent>(CreateSceneFlowSubscriber(
    repository: flowRepository,
    transaction: transaction,
  ));
  bus.subscribe<StartTaskEvent>(StartTaskSceneSubscriber(
    repository: sceneRepository,
    transaction: transaction,
  ));
  bus.subscribe<ChangeTaskOperationEvent>(ChangeTaskOperationSceneSubscriber(
    repository: sceneRepository,
    transaction: transaction,
  ));
  bus.subscribe<ResumeTaskEvent>(ResumeTaskSceneSubscriber(
    repository: sceneRepository,
    transaction: transaction,
  ));

  final sceneUseCase = CreateSceneUseCase(
    repository: sceneRepository,
    transaction: transaction,
    eventBus: bus,
  );

  final sceneID = (await sceneUseCase.execute(CreateSceneCommand(
    name: 'hello',
    genre: Genre.hobby.name,
  )))
      .result;

  var flow = await flowRepository.findByID(sceneID);
  if (flow != null) {
    flow = flow.addOperation(OperationDetail(
      name: OperationName('a'),
      color: const OperationColor(11),
    ));
    flow = flow.addOperation(OperationDetail(
      name: OperationName('b'),
      color: const OperationColor(11),
    ));

    await flowRepository.save(flow);
  }

  group('TaskUseCase test', () {
    test("StartTaskUseCase ChangeTaskOperationUseCase test", () async {
      final scene = await sceneRepository.findByID(sceneID);

      expect(scene, isNotNull);
      if (scene != null) {
        final usecase = StartTaskUseCase(
          repository: repository,
          flowRepository: flowRepository,
          boardRepository: boardRepository,
          transaction: transaction,
          eventBus: bus,
        );

        final id = (await usecase.execute(StartTaskCommand(
          sceneID: sceneID.value,
          content: 'yes',
        )))
            .result;
        await usecase.execute(StartTaskCommand(
          sceneID: sceneID.value,
          content: 'yes',
        ));

        final task = await repository.findStartedByID(id);
        expect(task, isNotNull);
        if (task != null) {
          expect(task.content.value, 'yes');

          final changeUseCase = ChangeTaskOperationUseCase(
            repository: repository,
            flowRepository: flowRepository,
            transaction: transaction,
            eventBus: bus,
          );

          await changeUseCase.execute(id.value);

          final changeTask = await repository.findStartedByID(id);
          expect(changeTask, isNotNull);
          if (changeTask != null) {
            expect(task.operationID != changeTask.operationID, isTrue);

            final updateScene = await sceneRepository.findByID(sceneID);

            expect(updateScene, isNotNull);
            if (updateScene != null) {
              expect(scene.lastModified != updateScene.lastModified, isTrue);
            }
          }
        }
      }
    });

    test("DiscardTaskUseCase ResumeTaskUseCase test", () async {
      final scene = await sceneRepository.findByID(sceneID);

      expect(scene, isNotNull);
      if (scene != null) {
        final usecase = StartTaskUseCase(
          repository: repository,
          boardRepository: boardRepository,
          flowRepository: flowRepository,
          transaction: transaction,
          eventBus: bus,
        );

        final id = (await usecase.execute(StartTaskCommand(
          sceneID: sceneID.value,
          content: 'yes',
        )))
            .result;

        final task = await repository.findStartedByID(id);
        expect(task, isNotNull);
        if (task != null) {
          expect(task.content.value, 'yes');

          final discardUseCase = DiscardTaskUseCase(
            repository: repository,
            boardRepository: boardRepository,
            transaction: transaction,
            eventBus: bus,
          );

          await discardUseCase.execute(id.value);

          expect(await repository.findStartedByID(id), isNull);
          final discardTask = await repository.findDiscardedByID(id);
          expect(discardTask, isNotNull);
          if (discardTask != null) {
            expect(discardTask.isDiscarded, isTrue);

            final resumeUseCase = ResumeTaskUseCase(
              repository: repository,
              boardRepository: boardRepository,
              transaction: transaction,
              eventBus: bus,
            );

            await resumeUseCase.execute(id.value);

            expect(await repository.findDiscardedByID(id), isNull);
            final startedTask = await repository.findStartedByID(id);
            expect(startedTask, isNotNull);
            if (startedTask != null) {
              expect(startedTask.isDiscarded, isFalse);
            }
          }
        }
      }
    });

    test("RemoveTaskUseCase test", () async {
      final scene = await sceneRepository.findByID(sceneID);

      expect(scene, isNotNull);
      if (scene != null) {
        final usecase = StartTaskUseCase(
          repository: repository,
          boardRepository: boardRepository,
          flowRepository: flowRepository,
          transaction: transaction,
          eventBus: bus,
        );

        final id = (await usecase.execute(StartTaskCommand(
          sceneID: sceneID.value,
          content: 'yes',
        )))
            .result;

        final task = await repository.findStartedByID(id);
        expect(task, isNotNull);
        if (task != null) {
          expect(task.content.value, 'yes');

          final discardUseCase = DiscardTaskUseCase(
            repository: repository,
            boardRepository: boardRepository,
            transaction: transaction,
            eventBus: bus,
          );

          await discardUseCase.execute(id.value);

          expect(await repository.findStartedByID(id), isNull);
          final discardTask = await repository.findDiscardedByID(id);
          expect(discardTask, isNotNull);
          if (discardTask != null) {
            expect(discardTask.isDiscarded, isTrue);

            final removeUseCase = RemoveTaskUseCase(
              repository: repository,
              transaction: transaction,
            );

            await removeUseCase.execute(id.value);

            expect(await repository.findStartedByID(id), isNull);
            expect(await repository.findDiscardedByID(id), isNull);
          }
        }
      }
    });

    test("DiscardedTaskUseCase and StartedTaskUseCase test", () async {
      final scene = await sceneRepository.findByID(sceneID);

      expect(scene, isNotNull);
      if (scene != null) {
        final usecase = StartTaskUseCase(
          repository: repository,
          boardRepository: boardRepository,
          flowRepository: flowRepository,
          transaction: transaction,
          eventBus: bus,
        );

        final id1 = (await usecase.execute(StartTaskCommand(
          sceneID: sceneID.value,
          content: 'yes',
        )))
            .result;
        await usecase.execute(StartTaskCommand(
          sceneID: sceneID.value,
          content: 'yes',
        ));
        await usecase.execute(StartTaskCommand(
          sceneID: sceneID.value,
          content: 'yes',
        ));

        final beforeDiscards = await query.allDiscardedBySceneID(sceneID);
        final beforeStarteds = await query.allStartedBySceneID(sceneID);

        final discardUseCase = DiscardTaskUseCase(
          repository: repository,
          boardRepository: boardRepository,
          transaction: transaction,
          eventBus: bus,
        );

        discardUseCase.execute(id1.value);

        final afterDiscards = await query.allDiscardedBySceneID(sceneID);
        final afterStarteds = await query.allStartedBySceneID(sceneID);

        expect(beforeDiscards.length < afterDiscards.length, isTrue);
        expect(beforeStarteds.length > afterStarteds.length, isTrue);
      }
    });
  });
}
