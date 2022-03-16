import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/flow/application/exception.dart';
import 'package:tasking/module/flow/application/usecase/add_operation_usecase.dart';
import 'package:tasking/module/flow/application/usecase/change_operation_usecase.dart';
import 'package:tasking/module/flow/application/usecase/remove_operation_usecase.dart';
import 'package:tasking/module/flow/application/usecase/reorder_operations_usecase.dart';
import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_query.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_repository.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/transaction.dart';
import 'package:tasking/module/task/infrastructure/sqlite/task_repository.dart';

void main() async {
  final helper = SQLiteHelper();

  File file = File(helper.currentDatabasePath());
  file.deleteSync();
  file.createSync();

  await helper.open();

  SceneSQLiteRepository sceneRepository = SceneSQLiteRepository(helper: helper);
  TaskSQLiteRepository taskRepository = TaskSQLiteRepository(helper: helper);
  FlowSQLiteQuery query = FlowSQLiteQuery(helper: helper);
  FlowSQLiteRepository repository = FlowSQLiteRepository(helper: helper);
  SQLiteTransaction transaction = SQLiteTransaction(helper: helper);

  final scene = CreatedScene.create(
    id: SceneID.generate(),
    name: SceneName('a1'),
    genre: Genre.hobby,
  );

  sceneRepository.store(scene);

  final flow = Flow.create(id: scene.id);

  repository.save(flow);

  group('FlowUseCase test', () {
    test("AddOperationUseCase and RemoveOperationUseCase test", () async {
      final findFlow = await repository.findByID(scene.id);

      expect(findFlow, isNotNull);
      if (findFlow != null) {
        final usecase = AddOperationUseCase(
          repository: repository,
          transaction: transaction,
        );

        await usecase.execute(AddOperationCommand(
          id: findFlow.id.value,
          name: '次',
          color: 2222,
        ));

        final addFlow = await repository.findByID(scene.id);

        expect(addFlow, isNotNull);
        if (addFlow != null) {
          expect(
              findFlow.operations.length < addFlow.operations.length, isTrue);

          final data = await query.detail(scene.id);
          expect(data, isNotNull);
          if (data != null) {
            expect(data.operations[1].name, '次');
          }

          final removeUseCase = RemoveOperationUseCase(
            repository: repository,
            taskRepository: taskRepository,
            transaction: transaction,
          );

          await removeUseCase.execute(RemoveOperationCommand(
            id: scene.id.value,
            operationID: addFlow.operations.last.id.value,
          ));

          final removeFlow = await repository.findByID(scene.id);

          expect(removeFlow, isNotNull);
          if (removeFlow != null) {
            expect(addFlow.operations.length > removeFlow.operations.length,
                isTrue);
          }
        }

        expect(() async {
          await usecase.execute(AddOperationCommand(
            id: SceneID.generate().value,
            name: 'aa',
            color: 11,
          ));
        }, throwsA(const TypeMatcher<NotFoundException>()));
      }
    });
    test("ChangeOperationUseCase test", () async {
      final findFlow = await repository.findByID(scene.id);

      expect(findFlow, isNotNull);
      if (findFlow != null) {
        final usecase = ChangeOperationUseCase(
          repository: repository,
          transaction: transaction,
        );

        await usecase.execute(ChangeOperationCommand(
          id: findFlow.id.value,
          operationID: flow.operations.first.id.value,
          name: 'EIF',
          color: 2222,
        ));

        final addUseCase = AddOperationUseCase(
          repository: repository,
          transaction: transaction,
        );

        await addUseCase.execute(AddOperationCommand(
          id: findFlow.id.value,
          name: 'WEWEWE',
          color: 2222,
        ));

        final changeFlow = await repository.findByID(scene.id);

        expect(changeFlow, isNotNull);
        if (changeFlow != null) {
          expect(
            changeFlow.operations.first.detail.name.value,
            'EIF',
          );
        }

        expect(() async {
          await usecase.execute(ChangeOperationCommand(
            id: findFlow.id.value,
            operationID: flow.operations.first.id.value,
            name: 'WEWEWE',
            color: 2222,
          ));
        }, throwsA(const TypeMatcher<NotUniqueOperationNameException>()));
      }
    });

    test("ReOrderOperationUseCase test", () async {
      final findFlow = await repository.findByID(scene.id);

      expect(findFlow, isNotNull);
      if (findFlow != null) {
        final usecase = AddOperationUseCase(
          repository: repository,
          transaction: transaction,
        );

        await usecase.execute(AddOperationCommand(
          id: findFlow.id.value,
          name: 'A',
          color: 2222,
        ));
        await usecase.execute(AddOperationCommand(
          id: findFlow.id.value,
          name: 'B',
          color: 2222,
        ));
        await usecase.execute(AddOperationCommand(
          id: findFlow.id.value,
          name: 'C',
          color: 2222,
        ));

        final addFlow = await repository.findByID(scene.id);

        expect(addFlow, isNotNull);
        if (addFlow != null) {
          final reorderUseCase = ReOrderOperationsUseCase(
            repository: repository,
            transaction: transaction,
          );

          var ids = addFlow.operations.map((e) => e.id.value).toList();
          ids = ids.reversed.toList();

          await reorderUseCase.execute(ReOrderOperationsCommand(
            id: scene.id.value,
            operationIDs: ids,
          ));

          final reorderFlow = await repository.findByID(scene.id);

          expect(reorderFlow, isNotNull);
          if (reorderFlow != null) {
            expect(ids.first, reorderFlow.operations.first.id.value);
            expect(addFlow.operations.first.id.value != ids.first, isTrue);
          }
        }
      }
    });
  });
}
