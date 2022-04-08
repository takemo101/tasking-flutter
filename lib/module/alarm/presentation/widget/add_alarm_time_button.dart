import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/presentation/notifier/alarm_time_notifier.dart';
import 'package:tasking/module/alarm/presentation/widget/input_alarm_time_dialog.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';

class AddAlarmTimeButton extends StatelessWidget {
  final AlarmTimeNotifier notifier;

  const AddAlarmTimeButton({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => InputAlarmTimeDialog(
        context: context,
        heading: '新規アラーム',
        dayOfWeeks: [DayOfWeekday.fromWeekday(now.weekday)],
        timeOfDay: TimeOfDay(
          hour: now.hour,
          minute: now.minute,
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
