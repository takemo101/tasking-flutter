import 'package:flutter/material.dart';
import 'package:tasking/module/scene/presentation/notifier/scene_notifier.dart';
import 'package:tasking/module/scene/presentation/widget/remove_scene_dialog.dart';

class RemoveSceneButton extends StatelessWidget {
  final SceneNotifier notifier;
  final String id;

  const RemoveSceneButton({
    required this.notifier,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () => RemoveSceneDialog(
        context: context,
        heading: 'シーン削除',
        onRemove: () async {
          await notifier.remove(id);
        },
      ).show(),
    );
  }
}
