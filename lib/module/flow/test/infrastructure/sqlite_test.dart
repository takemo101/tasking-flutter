import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/flow/domain/entity/operation.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/flow/domain/vo/flow_order.dart';
import 'package:tasking/module/flow/domain/vo/operation_color.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_repository.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_last_modified.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';

void main() async {
  SQLiteHelper helper = SQLiteHelper();

  File file = File(helper.currentDatabasePath());
  file.deleteSync();
  file.createSync();

  await helper.open();

  FlowSQLiteRepository repository = FlowSQLiteRepository(helper: helper);

  SceneSQLiteRepository sceneRepository = SceneSQLiteRepository(helper: helper);

  SceneID id = SceneID.generate();

  sceneRepository.store(
    CreatedScene.reconstruct(
      id: id,
      name: SceneName('sc1'),
      genre: Genre.jobs,
      lastModified: SceneLastModified.now(),
    ),
  );

  repository.store(
    CreatedFlow.reconstruct(
      id: id,
      operations: [
        Operation.reconstruct(
          id: OperationID('op1'),
          order: FlowOrder(0),
          detail: OperationDetail(
            name: OperationName('hello1'),
            color: const OperationColor(0),
          ),
        ),
        Operation.reconstruct(
          id: OperationID('op2'),
          order: FlowOrder(1),
          detail: OperationDetail(
            name: OperationName('hello2'),
            color: const OperationColor(0),
          ),
        ),
        Operation.reconstruct(
          id: OperationID('op3'),
          order: FlowOrder(1),
          detail: OperationDetail(
            name: OperationName('hello3'),
            color: const OperationColor(0),
          ),
        ),
      ],
    ),
  );

  group('FlowSQLiteRepository test', () {
    test("FlowSQLiteRepository store and findByID test", () async {
      final id = SceneID.generate();
      final firstOperationID = OperationID.generate();
      final firstOperationName = OperationName('name');
      var firstOperationColor = const OperationColor(11);

      await sceneRepository.store(
        CreatedScene.reconstruct(
          id: id,
          name: SceneName('sc2'),
          genre: Genre.jobs,
          lastModified: SceneLastModified.now(),
        ),
      );

      await repository.store(
        CreatedFlow.reconstruct(
          id: id,
          operations: [
            Operation.reconstruct(
              id: firstOperationID,
              order: FlowOrder(0),
              detail: OperationDetail(
                name: firstOperationName,
                color: firstOperationColor,
              ),
            ),
            Operation.reconstruct(
              id: OperationID('ops2'),
              order: FlowOrder(1),
              detail: OperationDetail(
                name: OperationName('hello2'),
                color: const OperationColor(0),
              ),
            ),
            Operation.reconstruct(
              id: OperationID('ops3'),
              order: FlowOrder(1),
              detail: OperationDetail(
                name: OperationName('hello3'),
                color: const OperationColor(0),
              ),
            ),
          ],
        ),
      );

      final flow = await repository.findByID(id);

      expect(flow, isNotNull);
      if (flow != null) {
        expect(flow.id, id);
        expect(flow.operations.first.id, firstOperationID);
        expect(flow.operations.first.detail.name, firstOperationName);
        expect(flow.operations.first.detail.color, firstOperationColor);
      }
    });

    test("FlowSQLiteRepository update test", () async {
      final id = SceneID.generate();

      final firstOperationID = OperationID.generate();
      final firstOperationName = OperationName('nameUpdate');
      var firstOperationColor = const OperationColor(333);

      await sceneRepository.store(
        CreatedScene.reconstruct(
          id: id,
          name: SceneName('scUpdate'),
          genre: Genre.jobs,
          lastModified: SceneLastModified.now(),
        ),
      );

      await repository.store(
        CreatedFlow.reconstruct(
          id: id,
          operations: [
            Operation.reconstruct(
              id: firstOperationID,
              order: FlowOrder(0),
              detail: OperationDetail(
                name: firstOperationName,
                color: firstOperationColor,
              ),
            ),
          ],
        ),
      );

      var flow = await repository.findByID(id);

      expect(flow, isNotNull);
      if (flow != null) {
        var before = flow.addOperation(
          OperationDetail(
            name: OperationName('hello'),
            color: const OperationColor(55),
          ),
        );

        flow = flow.changeOperation(
          firstOperationID,
          OperationDetail(
            name: OperationName('232323'),
            color: const OperationColor(66),
          ),
        );

        await repository.update(flow);

        var after = await repository.findByID(id);

        expect(after, isNotNull);
        if (after != null) {
          expect(after.id, id);
          expect(after.operations.first.id == firstOperationID, isTrue);
          expect(
            after.operations.first.detail.name != firstOperationName,
            isTrue,
          );
          expect(
            after.operations.first.detail.color != firstOperationColor,
            isTrue,
          );
          expect(
            after.operations.length != before.operations.length,
            isTrue,
          );
        }
      }
    });
  });
}
