import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/alarm/application/query/alarm_query.dart';
import 'package:tasking/module/alarm/domain/alarm_time_notificator.dart';
import 'package:tasking/module/alarm/domain/alarm_repository.dart';
import 'package:tasking/module/alarm/intrastracture/local_notificator/alarm_time_notificator.dart';
import 'package:tasking/module/alarm/intrastracture/sqlite/alarm_query.dart';
import 'package:tasking/module/alarm/intrastracture/sqlite/alarm_repository.dart';
import 'package:tasking/module/alarm/presentation/notifier/alarm_notifier.dart';
import 'package:tasking/module/alarm/presentation/notifier/alarm_time_notifier.dart';
import 'package:tasking/module/scene/scene_provider.dart';
import 'package:tasking/module/shared/shared_provider.dart';

final alarmRepositoryProvider = Provider<AlarmRepository>(
    (ref) => AlarmSQLiteRepository(helper: ref.read(sqliteHelperProvider)));

final alarmQueryProvider = Provider<AlarmQuery>(
    (ref) => AlarmSQLiteQuery(helper: ref.read(sqliteHelperProvider)));

final alarmTimeNotificatorProvider = Provider<AlarmTimeNotificator>(
    (ref) => AlarmTimeLocalNotificator()..init());

final alarmNotifierProvider =
    ChangeNotifierProvider.family<AlarmNotifier, String>(
        (ref, sceneID) => AlarmNotifier(
              sceneID,
              repository: ref.read(alarmRepositoryProvider),
              sceneRepository: ref.read(sceneRepositoryProvider),
              notificator: ref.read(alarmTimeNotificatorProvider),
              query: ref.read(alarmQueryProvider),
              transaction: ref.read(transactionProvider),
              eventBus: ref.read(domainEventBusProvider),
            )
              ..startedListUpdate()
              ..discardedListUpdate());

final alarmTimeNotifierProvider =
    ChangeNotifierProvider.family<AlarmTimeNotifier, String>(
        (ref, alarmID) => AlarmTimeNotifier(
              alarmID,
              repository: ref.read(alarmRepositoryProvider),
              notificator: ref.read(alarmTimeNotificatorProvider),
              query: ref.read(alarmQueryProvider),
              transaction: ref.read(transactionProvider),
              eventBus: ref.read(domainEventBusProvider),
            )..timesUpdate());
