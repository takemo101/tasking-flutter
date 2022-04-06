import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/presentation/notifier/alarm_notifier.dart';
import 'package:tasking/module/alarm/presentation/widget/alarm_card.dart';
import 'package:tasking/module/shared/presentation/route.dart';
import 'package:tasking/module/shared/presentation/widget/empty_container.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';

class StartedAlarmList extends StatelessWidget {
  final AlarmNotifier notifier;

  const StartedAlarmList({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = notifier.startedList;

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
                        icon: Icons.timer_outlined,
                        onPressed: () async {
                          Navigator.of(context)
                              .pushNamed(
                            AppRoute.alarmTimesPage.route,
                            arguments: alarm,
                          )
                              .then((_) {
                            notifier.startedListUpdate();
                          });
                        },
                      ),
                      ListIconButton(
                        icon: Icons.close,
                        onPressed: () async {
                          await notifier.discard(alarm.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          : const EmptyContainer('新規タスクを追加してください'),
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
  }
}
