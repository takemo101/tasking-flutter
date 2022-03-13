import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/flow/application/subscriber/create_scene_flow_subscriber.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_repository.dart';
import 'package:tasking/module/scene/application/usecase/create_scene_usecase.dart';
import 'package:tasking/module/scene/domain/event/scene_event.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';

import 'package:tasking/module/scene/infrastructure/sqlite/scene_query.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/shared/infrastructure/event.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/transaction.dart';

void main() async {
  final helper = SQLiteHelper();

  File file = File(helper.currentDatabasePath());
  file.deleteSync();
  file.createSync();

  await helper.open();

  SceneSQLiteRepository repository = SceneSQLiteRepository(helper: helper);
  SceneSQLiteQuery query = SceneSQLiteQuery(helper: helper);
  FlowSQLiteRepository flowRepository = FlowSQLiteRepository(helper: helper);
  SQLiteTransaction transaction = SQLiteTransaction(helper: helper);
  SyncDomainEventBus bus = SyncDomainEventBus();

  bus.subscribe<CreateSceneEvent>(CreateSceneFlowSubscriber(
    repository: flowRepository,
    transaction: transaction,
  ));

  repository.store(
    CreatedScene.create(
      id: SceneID.generate(),
      name: SceneName('a1'),
      genre: Genre.hobby,
    ),
  );
  repository.store(
    CreatedScene.create(
      id: SceneID.generate(),
      name: SceneName('a2'),
      genre: Genre.hobby,
    ),
  );
  repository.store(
    CreatedScene.create(
      id: SceneID.generate(),
      name: SceneName('a'),
      genre: Genre.hobby,
    ),
  );

  group('SceneUseCase test', () {
    test("CreateSceneUseCase and CreateSceneEvent test", () async {
      final createUsecase = CreateSceneUseCase(
        repository: repository,
        transaction: transaction,
        eventBus: bus,
      );

      final id = await createUsecase.execute(const CreateSceneCommand(
        name: 'hello',
        genre: 'jobs',
      ));

      final scene = await repository.findByID(id);

      expect(scene, isNotNull);
      if (scene != null) {
        expect(scene.name.value, 'hello');

        // create scene event check
        final flow = await flowRepository.findByID(id);

        expect(flow, isNotNull);
        if (flow != null) {
          expect(flow.id, scene.id);
          expect(flow.operations.length, 1);
        }
      }
    });

    test("RemoveSceneUseCase and SceneListUseCase test", () async {
      final createUsecase = CreateSceneUseCase(
        repository: repository,
        transaction: transaction,
        eventBus: bus,
      );

      final id = await createUsecase.execute(const CreateSceneCommand(
        name: 'hello2',
        genre: 'jobs',
      ));

      final scene = await repository.findByID(id);

      expect(scene, isNotNull);
      if (scene != null) {
        expect(scene.name.value, 'hello2');

        final beforeAll = await query.all();

        await repository.remove(scene.remove());

        final afterAll = await query.all();

        expect(beforeAll.length > afterAll.length, isTrue);
      }
    });
  });
}
