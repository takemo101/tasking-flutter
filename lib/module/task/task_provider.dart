import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/flow/flow_provider.dart';
import 'package:tasking/module/shared/shared_provider.dart';
import 'package:tasking/module/task/application/query/task_query.dart';
import 'package:tasking/module/task/domain/board_repository.dart';
import 'package:tasking/module/task/domain/task_repository.dart';
import 'package:tasking/module/task/infrastructure/sqlite/board_repository.dart';
import 'package:tasking/module/task/infrastructure/sqlite/task_query.dart';
import 'package:tasking/module/task/infrastructure/sqlite/task_repository.dart';
import 'package:tasking/module/task/presentation/notifier/task_notifier.dart';

final taskRepositoryProvider = Provider<TaskRepository>(
    (ref) => TaskSQLiteRepository(helper: ref.read(sqliteHelperProvider)));

final taskQueryProvider = Provider<TaskQuery>(
    (ref) => TaskSQLiteQuery(helper: ref.read(sqliteHelperProvider)));

final boardRepositoryProvider = Provider<BoardRepository>(
    (ref) => BoardSQLiteRepository(helper: ref.read(sqliteHelperProvider)));

final taskNotifierProvider =
    ChangeNotifierProvider<TaskNotifier>((ref) => TaskNotifier(
          repository: ref.read(taskRepositoryProvider),
          flowRepository: ref.read(flowRepositoryProvider),
          boardRepository: ref.read(boardRepositoryProvider),
          query: ref.read(taskQueryProvider),
          transaction: ref.read(sqliteTransactionProvider),
          eventBus: ref.read(domainEventBusProvider),
        ));
