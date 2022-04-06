import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/presentation/notifier/alarm_notifier.dart';
import 'package:tasking/module/alarm/presentation/widget/input_alarm_dialog.dart';

class StartAlarmButton extends StatelessWidget {
  final AlarmNotifier notifier;

  const StartAlarmButton({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => InputAlarmDialog(
        context: context,
        heading: '新規タスク',
        onSave: (content) async {
          return await notifier.start(
            content: content,
          );
        },
      ).show(),
    );
  }
}
