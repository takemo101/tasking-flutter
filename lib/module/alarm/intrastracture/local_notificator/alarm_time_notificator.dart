import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tasking/module/alarm/domain/alarm_time_notificator.dart';
import 'package:tasking/module/alarm/domain/entity/alarm_time.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_content.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';

import 'package:timezone/timezone.dart' as tz;

/// https://medium.com/flutter-community/local-notifications-in-flutter-746eb1d606c6

class AlarmTimeLocalNotificator implements AlarmTimeNotificator {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    var initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
      },
    );
  }

  @override
  Future<void> make(
    AlarmContent content,
    AlarmTime time,
  ) async {
    await cancel(time);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      time.id.value,
      'タスクの時間です',
      channelDescription: content.value,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    final now = tz.TZDateTime.now(tz.local);

    var date = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.timeOfDay.hour,
      time.timeOfDay.minute,
    );

    date = date.isBefore(now) ? date.add(const Duration(days: 1)) : date;

    for (final week in time.dayOfWeeks.value) {
      var schedule = tz.TZDateTime.from(date, date.location);
      while (schedule.weekday != week.weekday) {
        schedule = schedule.add(const Duration(days: 1));
      }

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        time.id.toNumberID(week),
        'タスクの時間です',
        content.value,
        schedule,
        platformChannelSpecifics,
        payload: time.id.value,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  @override
  Future<void> cancel(
    AlarmTime time,
  ) async {
    for (final week in DayOfWeek.values) {
      await flutterLocalNotificationsPlugin.cancel(time.id.toNumberID(week));
    }
  }
}
