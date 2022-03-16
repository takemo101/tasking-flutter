import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tasking/module/scene/presentation/widget/create_scene_button.dart';
import 'package:tasking/module/scene/presentation/widget/remove_scene_button.dart';
import 'package:tasking/module/scene/presentation/widget/update_scene_button.dart';
import 'package:tasking/module/scene/scene_provider.dart';
import 'package:tasking/module/shared/infrastructure/string.dart';
import 'package:tasking/module/shared/presentation/route.dart';
import 'package:tasking/module/shared/presentation/widget/empty_container.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';
import 'package:tasking/module/shared/presentation/widget/side_action_button.dart';

class SceneListPage extends ConsumerWidget {
  const SceneListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(sceneNotifierProvider);
    final list = notifier.list;

    return Scaffold(
      appBar: AppBar(
        title: const Text('タスクシーン'),
        actions: [
          AppBarActionButton(
            icon: Icons.menu_book,
            text: '使い方',
            onPressed: () async {
              //
            },
          ),
        ],
      ),
      body: Container(
        child: list.isNotEmpty
            ? ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final scene = list[index];
                  return ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
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
                          RemoveSceneButton(
                            notifier: notifier,
                            id: scene.id,
                          ),
                          UpdateSceneButton(
                            notifier: notifier,
                            scene: scene,
                          ),
                          ListIconButton(
                            icon: Icons.low_priority,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRoute.flowPage.route,
                                arguments: scene,
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(
                          AppRoute.taskPage.route,
                          arguments: scene,
                        )
                            .then((_) {
                          notifier.listUpdate();
                        });
                      });
                },
              )
            : const EmptyContainer('新規シーンを追加してください'),
        color: const Color.fromRGBO(255, 255, 255, 1),
      ),
      floatingActionButton: CreateSceneButton(notifier: notifier),
    );
  }
}
