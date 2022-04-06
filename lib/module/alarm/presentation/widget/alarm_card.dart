import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/application/dto/alarm_data.dart';

class AlarmCard extends StatelessWidget {
  final AlarmData alarm;
  final Widget? trailing;

  const AlarmCard({
    required this.alarm,
    this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alarm.content),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
