import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/presentation/notifier/alarm_notifier.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';
import 'package:tasking/module/shared/presentation/widget/remove_dialog.dart';

class RemoveAlarmButton extends StatelessWidget {
  final AlarmNotifier notifier;
  final String id;

  const RemoveAlarmButton({
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
          (await notifier.remove(id)).exception();
        },
      ).show(),
    );
  }
}
