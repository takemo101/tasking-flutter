import 'package:flutter/material.dart';
import 'package:tasking/module/task/presentation/notifier/task_notifier.dart';
import 'package:tasking/module/task/presentation/widget/input_task_dialog.dart';

class StartTaskButton extends StatelessWidget {
  final TaskNotifier notifier;

  const StartTaskButton({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => InputTaskDialog(
        context: context,
        heading: '新規タスク',
        onSave: (content) async {
          await notifier.start(
            content: content,
          );
        },
      ).show(),
    );
  }
}
