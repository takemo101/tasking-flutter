import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/alarm/alarm_provider.dart';
import 'package:tasking/module/alarm/presentation/widget/discarded_alarm_list.dart';
import 'package:tasking/module/alarm/presentation/widget/start_alarm_button.dart';
import 'package:tasking/module/alarm/presentation/widget/started_alarm_list.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/shared/infrastructure/string.dart';

class AlarmListPage extends ConsumerWidget {
  final SceneData scene;

  const AlarmListPage({required this.scene, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(alarmNotifierProvider(scene.id));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(StringHelper.limit(scene.name, limit: 8) + 'のタスク'),
          bottom: const TabBar(tabs: <Widget>[
            Tab(icon: Icon(Icons.task_alt_sharp)),
            Tab(icon: Icon(Icons.delete)),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            StartedAlarmList(
              notifier: notifier,
            ),
            DiscardedAlarmList(
              notifier: notifier,
            ),
          ],
        ),
        floatingActionButton: StartAlarmButton(notifier: notifier),
      ),
    );
  }
}
