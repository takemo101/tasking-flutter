import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/presentation/notifier/alarm_time_notifier.dart';
import 'package:tasking/module/alarm/presentation/widget/input_alarm_time_dialog.dart';

class AddAlarmTimeButton extends StatelessWidget {
  final AlarmTimeNotifier notifier;

  const AddAlarmTimeButton({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => InputAlarmTimeDialog(
        context: context,
        heading: '新規アラーム',
        timeOfDay: const TimeOfDay(
          hour: 0,
          minute: 0,
        ),
        onSave: (timeOfDay, dayOfWeeks) async {
          return await notifier.add(
            timeOfDay: timeOfDay,
            dayOfWeeks: dayOfWeeks,
          );
        },
      ).show(),
    );
  }
}
