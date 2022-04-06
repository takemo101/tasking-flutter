import 'package:flutter/material.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/flow.dart' as domain_flow;
import 'package:tasking/module/flow/domain/vo/operation_color.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_repository_mapper.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository_mapper.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/migration.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasking/module/task/domain/board.dart';
import 'package:tasking/module/task/domain/task.dart';
import 'package:tasking/module/task/domain/vo/task_content.dart';
import 'package:tasking/module/task/domain/vo/task_id.dart';
import 'package:tasking/module/task/infrastructure/sqlite/board_repository_mapper.dart';
import 'package:tasking/module/task/infrastructure/sqlite/task_repository_mapper.dart';

class RecordFactory implements SQLiteRecordFactory {
  const RecordFactory();

  @override
  void factory(Batch batch) {
    final scene = insertScene(batch);
    final flow = insertFlow(batch, scene);
    insertTask(batch, scene, flow);
  }

  Scene insertScene(Batch batch) {
    // scene insert
    final scene = CreatedScene.create(
      id: SceneID.generate(),
      name: SceneName('日々の雑務'),
      genre: Genre.life,
    );

    batch.insert(
      'scenes',
      SceneRepositoryMapper().fromCreatedSceneToMap(scene),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return scene;
  }

  domain_flow.Flow insertFlow(Batch batch, Scene scene) {
    var flow = domain_flow.Flow.create(id: scene.id);

    flow = flow.addOperation(
      OperationDetail(
        name: OperationName('作業中'),
        color: OperationColor(Colors.yellow.value),
      ),
    );
    flow = flow.addOperation(
      OperationDetail(
        name: OperationName('完了'),
        color: OperationColor(Colors.black.value),
      ),
    );

    final mapper = FlowRepositoryMapper();

    final maps = mapper.fromFlowToOperationMapList(flow);

    for (final map in maps) {
      batch.insert(
        'operations',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return flow;
  }

  void insertTask(Batch batch, Scene scene, domain_flow.Flow flow) {
    final task = StartedTask.start(
      id: TaskID.generate(),
      content: TaskContent('部屋の掃除をする！'),
      scene: scene,
      operationID: flow.defaultOperationID,
    );

    batch.insert(
      'tasks',
      TaskRepositoryMapper().fromCreatedTaskToMap(task),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    var board = Board.empty(id: scene.id);
    board = board.addPinByStartedTask(task);

    final maps = BoardRepositoryMapper().fromBoardToPinMapList(board);

    for (final map in maps) {
      batch.insert(
        'pins',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
