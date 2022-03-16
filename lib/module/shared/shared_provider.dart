import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/flow/application/subscriber/create_scene_flow_subscriber.dart';
import 'package:tasking/module/flow/flow_provider.dart';
import 'package:tasking/module/scene/application/subscriber/change_task_operation_scene_subscriber.dart';
import 'package:tasking/module/scene/application/subscriber/resume_task_scene_subscriber.dart';
import 'package:tasking/module/scene/application/subscriber/start_task_scene_subscriber.dart';
import 'package:tasking/module/scene/domain/event/scene_event.dart';
import 'package:tasking/module/scene/scene_provider.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';
import 'package:tasking/module/shared/infrastructure/event.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/transaction.dart';
import 'package:tasking/module/task/domain/event/task_event.dart';

final sqliteHelperProvider = Provider.autoDispose<SQLiteHelper>((ref) {
  final helper = SQLiteHelper();

  ref.onDispose(() {
    helper.dispose();
  });

  return helper;
});

final transactionProvider = Provider<Transaction>(
    (ref) => SQLiteTransaction(helper: ref.read(sqliteHelperProvider)));

final domainEventBusProvider = Provider.autoDispose<DomainEventBus>((ref) {
  SyncDomainEventBus bus = SyncDomainEventBus();

  bus
    ..subscribe<ChangeTaskOperationEvent>(
      ChangeTaskOperationSceneSubscriber(
        repository: ref.read(sceneRepositoryProvider),
        transaction: ref.read(transactionProvider),
      ),
    )
    ..subscribe<ResumeTaskEvent>(
      ResumeTaskSceneSubscriber(
        repository: ref.read(sceneRepositoryProvider),
        transaction: ref.read(transactionProvider),
      ),
    )
    ..subscribe<StartTaskEvent>(
      StartTaskSceneSubscriber(
        repository: ref.read(sceneRepositoryProvider),
        transaction: ref.read(transactionProvider),
      ),
    )
    ..subscribe<CreateSceneEvent>(
      CreateSceneFlowSubscriber(
        repository: ref.read(flowRepositoryProvider),
        transaction: ref.read(transactionProvider),
      ),
    );

  return bus;
});
