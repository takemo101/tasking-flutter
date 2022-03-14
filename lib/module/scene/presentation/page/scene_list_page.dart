import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/scene/presentation/widget/create_scene_button.dart';
import 'package:tasking/module/scene/presentation/widget/remove_scene_button.dart';
import 'package:tasking/module/scene/presentation/widget/update_scene_button.dart';
import 'package:tasking/module/scene/scene_provider.dart';

class SceneListPage extends ConsumerWidget {
  const SceneListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(sceneNotifierProvider);
    final list = notifier.list;

    return Scaffold(
      appBar: AppBar(
        title: const Text('シーンリスト'),
      ),
      body: Container(
        child: ListView.builder(
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
                title: Text(scene.name),
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
                  ],
                ),
                onTap: () {
                  print('タスクリストへ');
                });
          },
        ),
        color: const Color.fromRGBO(255, 255, 255, 1),
      ),
      floatingActionButton: CreateSceneButton(notifier: notifier),
    );
  }
}
