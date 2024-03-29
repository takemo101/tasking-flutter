import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/domain/vo/scene_type.dart';
import 'package:tasking/module/scene/presentation/notifier/scene_sort_notifier.dart';
import 'package:tasking/module/scene/presentation/widget/create_scene_button.dart';
import 'package:tasking/module/scene/presentation/widget/manual_drawer.dart';
import 'package:tasking/module/scene/presentation/widget/remove_scene_button.dart';
import 'package:tasking/module/scene/presentation/widget/update_scene_button.dart';
import 'package:tasking/module/scene/scene_provider.dart';
import 'package:tasking/module/shared/infrastructure/string.dart';
import 'package:tasking/module/shared/presentation/route.dart';
import 'package:tasking/module/shared/presentation/widget/empty_container.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';
import 'package:tasking/module/shared/presentation/widget/side_action_button.dart';
import 'package:tasking/module/shared/presentation/widget/sort_toggle_buttons.dart';

class SceneListPage extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  SceneListPage({Key? key}) : super(key: key);

  List<SceneData> makeSceneDataList(List<SceneData> list, SceneSort sort) {
    switch (sort) {
      case SceneSort.task:
        return list
            .where((scene) => scene.type.label == SceneType.task.name)
            .toList();
      case SceneSort.alarm:
        return list
            .where((scene) => scene.type.label == SceneType.alarm.name)
            .toList();
      default:
        return list;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(sceneNotifierProvider);
    final sort = ref.watch(sceneSortStateNotifierProvider);

    final list = makeSceneDataList(notifier.list, sort);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('シーン'),
        automaticallyImplyLeading: false,
        actions: [
          AppBarActionButton(
            icon: Icons.menu_book,
            text: '使い方',
            onPressed: () async {
              _key.currentState!.openDrawer();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SortToggleButtons<SceneSort>(
                isSelected: SceneSort.values.map((s) => s == sort).toList(),
                onPressed: (index) {
                  final change =
                      SceneSort.values.firstWhere((s) => s.index == index);

                  ref
                      .read(sceneSortStateNotifierProvider.notifier)
                      .change(change);
                },
                toggles: SceneSort.values,
                toText: (s) => Text(s.jpname),
              ),
            ),
            Flexible(
              child: list.isNotEmpty
                  ? ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final scene = list[index];
                        return ListTile(
                            leading: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  scene.type.name,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  scene.genre.name,
                                  style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('yyyy.MM.dd HH:mm')
                                      .format(scene.lastModified),
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                Text(StringHelper.limit(
                                  scene.name,
                                  limit: 8,
                                )),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (scene.type.label == SceneType.task.name)
                                  ListIconButton(
                                    icon: Icons.low_priority,
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        AppRoute.flowPage.route,
                                        arguments: scene,
                                      );
                                    },
                                  ),
                                UpdateSceneButton(
                                  notifier: notifier,
                                  scene: scene,
                                ),
                                RemoveSceneButton(
                                  notifier: notifier,
                                  id: scene.id,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(
                                scene.type.label == SceneType.task.name
                                    ? AppRoute.taskPage.route
                                    : AppRoute.alarmPage.route,
                                arguments: scene,
                              )
                                  .then((_) {
                                notifier.listUpdate();
                              });
                            });
                      },
                    )
                  : const EmptyContainer('新規シーンを追加してください'),
            ),
          ],
        ),
        color: const Color.fromRGBO(255, 255, 255, 1),
      ),
      drawer: ManualDrawer(
        children: [
          ListTile(
            title: const Text('アプリの利用手順'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoute.manualHowToUsePage.route,
              );
            },
          ),
          ListTile(
            title: const Text('シーンについて'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoute.manualAboutTheScenePage.route,
              );
            },
          ),
          ListTile(
            title: const Text('フローについて'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoute.manualAboutTheFlowPage.route,
              );
            },
          ),
          ListTile(
            title: const Text('アラームについて'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoute.manualAboutTheAlarmPage.route,
              );
            },
          ),
          ListTile(
            title: const Text('タスクについて'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoute.manualAboutTheTaskPage.route,
              );
            },
          ),
        ],
      ),
      floatingActionButton: CreateSceneButton(notifier: notifier),
    );
  }
}
