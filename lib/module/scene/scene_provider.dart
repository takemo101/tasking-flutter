import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/scene/application/query/scene_query.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_query.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/scene/presentation/notifier/scene_notifier.dart';
import 'package:tasking/module/shared/shared_provider.dart';

final sceneRepositoryProvider = Provider<SceneRepository>(
    (ref) => SceneSQLiteRepository(helper: ref.read(sqliteHelperProvider)));

final sceneQueryProvider = Provider<SceneQuery>(
    (ref) => SceneSQLiteQuery(helper: ref.read(sqliteHelperProvider)));

final sceneNotifierProvider =
    ChangeNotifierProvider<SceneNotifier>((ref) => SceneNotifier(
          repository: ref.read(sceneRepositoryProvider),
          query: ref.read(sceneQueryProvider),
          transaction: ref.read(transactionProvider),
          eventBus: ref.read(domainEventBusProvider),
        )..listUpdate());
