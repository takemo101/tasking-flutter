import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/flow/application/subscriber/create_scene_flow_subscriber.dart';
import 'package:tasking/module/flow/flow_provider.dart';
import 'package:tasking/module/scene/application/subscriber/change_task_operation_scene_subscriber.dart';
import 'package:tasking/module/scene/application/subscriber/resume_task_scene_subscriber.dart';
import 'package:tasking/module/scene/application/subscriber/start_task_scene_subscriber.dart';
import 'package:tasking/module/scene/domain/event/scene_event.dart';
import 'package:tasking/module/scene/scene_provider.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/infrastructure/event.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/transaction.dart';
import 'package:tasking/module/task/domain/event/task_event.dart';

final sqliteHelperProvider = Provider.autoDispose<SQLiteHelper>((ref) {
  final helper = SQLiteHelper();

  ref.onDispose(() async => await helper.dispose());

  return helper;
});

final sqliteTransactionProvider = Provider<SQLiteTransaction>(
    (ref) => SQLiteTransaction(helper: ref.read(sqliteHelperProvider)));

final domainEventBusProvider = Provider.autoDispose<DomainEventBus>((ref) {
  SyncDomainEventBus bus = SyncDomainEventBus();

  bus
    ..subscribe<ChangeTaskOperationEvent>(
      ChangeTaskOperationSceneSubscriber(
        repository: ref.read(sceneRepositoryProvider),
        transaction: ref.read(sqliteTransactionProvider),
      ),
    )
    ..subscribe<ResumeTaskEvent>(
      ResumeTaskSceneSubscriber(
        repository: ref.read(sceneRepositoryProvider),
        transaction: ref.read(sqliteTransactionProvider),
      ),
    )
    ..subscribe<StartTaskEvent>(
      StartTaskSceneSubscriber(
        repository: ref.read(sceneRepositoryProvider),
        transaction: ref.read(sqliteTransactionProvider),
      ),
    )
    ..subscribe<CreateSceneEvent>(
      CreateSceneFlowSubscriber(
        repository: ref.read(flowRepositoryProvider),
        transaction: ref.read(sqliteTransactionProvider),
      ),
    );

  ref.onDispose(() => bus.clear());

  return bus;
});
