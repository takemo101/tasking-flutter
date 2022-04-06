import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/presentation/notifier/alarm_notifier.dart';
import 'package:tasking/module/alarm/presentation/widget/alarm_card.dart';
import 'package:tasking/module/alarm/presentation/widget/remove_alarm_button.dart';
import 'package:tasking/module/shared/presentation/widget/empty_container.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';

class DiscardedAlarmList extends StatelessWidget {
  final AlarmNotifier notifier;

  const DiscardedAlarmList({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = notifier.discardedList;

    return Container(
      child: list.isNotEmpty
          ? ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final alarm = list[index];
                return AlarmCard(
                  alarm: alarm,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListIconButton(
                        icon: Icons.undo,
                        onPressed: () async {
                          await notifier.resume(alarm.id);
                        },
                      ),
                      RemoveAlarmButton(notifier: notifier, id: alarm.id)
                    ],
                  ),
                );
              },
            )
          : const EmptyContainer('破棄したタスクはありません'),
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
  }
}
