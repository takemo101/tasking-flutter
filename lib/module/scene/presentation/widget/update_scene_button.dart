import 'package:flutter/material.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/presentation/notifier/scene_notifier.dart';
import 'package:tasking/module/scene/presentation/widget/input_scene_dialog.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';

class UpdateSceneButton extends StatelessWidget {
  final SceneNotifier notifier;
  final SceneData scene;

  const UpdateSceneButton({
    required this.notifier,
    required this.scene,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListIconButton(
      icon: Icons.edit,
      onPressed: () => InputSceneDialog(
        context: context,
        heading: 'シーン編集',
        genre: scene.genre,
        name: scene.name,
        onSave: (name, genre) async {
          await notifier.update(
            id: scene.id,
            name: name,
            genre: genre,
          );
        },
      ).show(),
    );
  }
}
