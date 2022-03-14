import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/flow/application/query/flow_query.dart';

import 'package:tasking/module/flow/domain/flow_repository.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_query.dart';
import 'package:tasking/module/flow/infrastructure/sqlite/flow_repository.dart';
import 'package:tasking/module/flow/presentation/notifier/flow_notifier.dart';
import 'package:tasking/module/shared/shared_provider.dart';

final flowRepositoryProvider = Provider<FlowRepository>(
    (ref) => FlowSQLiteRepository(helper: ref.read(sqliteHelperProvider)));

final flowQueryProvider = Provider<FlowQuery>(
    (ref) => FlowSQLiteQuery(helper: ref.read(sqliteHelperProvider)));

final flowNotifierProvider =
    ChangeNotifierProvider<FlowNotifier>((ref) => FlowNotifier(
          repository: ref.read(flowRepositoryProvider),
          query: ref.read(flowQueryProvider),
          transaction: ref.read(sqliteTransactionProvider),
        ));
