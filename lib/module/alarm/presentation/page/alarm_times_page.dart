import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/alarm/alarm_provider.dart';
import 'package:tasking/module/alarm/application/dto/alarm_data.dart';
import 'package:tasking/module/alarm/presentation/widget/add_alarm_time_button.dart';
import 'package:tasking/module/alarm/presentation/widget/remove_alarm_time_button.dart';
import 'package:tasking/module/alarm/presentation/widget/update_alarm_time_button.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';
import 'package:tasking/module/shared/presentation/widget/empty_container.dart';

class AlarmTimesPage extends ConsumerWidget {
  final AlarmData alarm;

  const AlarmTimesPage({required this.alarm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(alarmTimeNotifierProvider(alarm.id));
    final times = notifier.alarmTimes;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'アラーム設定',
        ),
      ),
      body: Container(
        child: times.times.isNotEmpty
            ? ListView.builder(
                itemCount: times.times.length,
                itemBuilder: (context, index) {
                  final time = times.times[index];

                  return ListTile(
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          time.timeOfDay.hour.toString().padLeft(2, "0") +
                              ':' +
                              time.timeOfDay.minute.toString().padLeft(2, "0"),
                          style: const TextStyle(
                            fontSize: 40,
                          ),
                        ),
                        Row(
                          children: [
                            for (final week in DayOfWeek.values)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  week.jpname,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: time.dayOfWeeks.contains(week)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: time.dayOfWeeks.contains(week)
                                        ? Colors.black
                                        : Colors.black26,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Switch(
                          value: time.isActive,
                          onChanged: (_) {
                            notifier.toggle(time.id);
                          },
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                        ),
                        UpdateAlarmTimeButton(
                          notifier: notifier,
                          time: time,
                        ),
                        RemoveAlarmTimeButton(
                          notifier: notifier,
                          timeID: time.id,
                        ),
                      ],
                    ),
                  );
                },
              )
            : const EmptyContainer('新規アラームを追加してください'),
        color: const Color.fromRGBO(255, 255, 255, 1),
      ),
      floatingActionButton:
          times.canAddTime ? AddAlarmTimeButton(notifier: notifier) : null,
    );
  }
}
