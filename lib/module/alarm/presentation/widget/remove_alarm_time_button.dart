import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/presentation/notifier/alarm_time_notifier.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';
import 'package:tasking/module/shared/presentation/widget/remove_dialog.dart';

class RemoveAlarmTimeButton extends StatelessWidget {
  final AlarmTimeNotifier notifier;
  final String timeID;

  const RemoveAlarmTimeButton({
    required this.notifier,
    required this.timeID,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListIconButton(
      icon: Icons.delete,
      onPressed: () => RemoveDialog(
        context: context,
        title: 'アラーム削除',
        message: 'このアラームを削除してもよろしいですか？',
        onRemove: () async {
          (await notifier.remove(timeID)).exception();
        },
      ).show(),
    );
  }
}
