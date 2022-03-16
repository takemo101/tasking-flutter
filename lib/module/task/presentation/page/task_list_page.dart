import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/shared/infrastructure/string.dart';
import 'package:tasking/module/shared/presentation/widget/side_action_button.dart';
import 'package:tasking/module/task/presentation/widget/discarded_task_list.dart';
import 'package:tasking/module/task/presentation/widget/start_task_button.dart';
import 'package:tasking/module/task/presentation/widget/started_task_list.dart';
import 'package:tasking/module/task/task_provider.dart';

class TaskListPage extends ConsumerWidget {
  final SceneData scene;

  const TaskListPage({required this.scene, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(taskNotifierProvider(scene.id));

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
          actions: [
            AppBarActionButton(
              icon: Icons.swap_vert,
              text: '整頓',
              onPressed: () async {
                await notifier.tidy();
              },
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            StartedTaskList(
              notifier: notifier,
            ),
            DiscardedTaskList(
              notifier: notifier,
            ),
          ],
        ),
        floatingActionButton: StartTaskButton(notifier: notifier),
      ),
    );
  }
}
