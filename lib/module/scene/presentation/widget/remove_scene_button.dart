import 'package:flutter/material.dart';
import 'package:tasking/module/scene/presentation/notifier/scene_notifier.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';
import 'package:tasking/module/shared/presentation/widget/remove_dialog.dart';

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
    return ListIconButton(
      icon: Icons.delete,
      onPressed: () => RemoveDialog(
        context: context,
        title: 'シーン削除',
        message: 'このシーンを削除してもよろしいですか？',
        onRemove: () async {
          await notifier.remove(id);
        },
      ).show(),
    );
  }
}
