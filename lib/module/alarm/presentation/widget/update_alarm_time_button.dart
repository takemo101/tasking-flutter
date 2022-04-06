import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/application/dto/alarm_data.dart';
import 'package:tasking/module/alarm/presentation/notifier/alarm_time_notifier.dart';
import 'package:tasking/module/alarm/presentation/widget/input_alarm_time_dialog.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';

class UpdateAlarmTimeButton extends StatelessWidget {
  final AlarmTimeNotifier notifier;
  final AlarmTimeData time;

  const UpdateAlarmTimeButton({
    required this.notifier,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListIconButton(
      icon: Icons.edit,
      onPressed: () => InputAlarmTimeDialog(
        context: context,
        heading: 'アラーム編集',
        timeOfDay: time.timeOfDay,
        dayOfWeeks: time.dayOfWeeks,
        onSave: (timeOfDay, dayOfWeeks) async {
          return await notifier.change(
            timeID: time.id,
            timeOfDay: timeOfDay,
            dayOfWeeks: dayOfWeeks,
          );
        },
      ).show(),
    );
  }
}
