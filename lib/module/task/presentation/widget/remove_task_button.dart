import 'package:flutter/material.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';
import 'package:tasking/module/shared/presentation/widget/remove_dialog.dart';
import 'package:tasking/module/task/presentation/notifier/task_notifier.dart';

class RemoveTaskButton extends StatelessWidget {
  final TaskNotifier notifier;
  final String id;

  const RemoveTaskButton({
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
        title: 'タスク削除',
        message: 'このタスクを削除してもよろしいですか？',
        onRemove: () async {
          await notifier.remove(id);
        },
      ).show(),
    );
  }
}
