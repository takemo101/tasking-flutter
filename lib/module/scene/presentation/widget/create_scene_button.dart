import 'package:flutter/material.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/presentation/notifier/scene_notifier.dart';
import 'package:tasking/module/scene/presentation/widget/input_scene_dialog.dart';

class CreateSceneButton extends StatelessWidget {
  final SceneNotifier notifier;

  const CreateSceneButton({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => InputSceneDialog(
        context: context,
        heading: '新規シーン',
        genre: GenreData.inital(),
        onSave: (name, genre) async {
          await notifier.create(
            name: name,
            genre: genre,
          );
        },
      ).show(),
    );
  }
}
