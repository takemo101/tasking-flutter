import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/alarm/domain/alarm.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_content.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_day_of_weeks.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_notif_time_of_day.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/domain/vo/scene_type.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';

void main() {
  final sceneID = SceneID.generate();
  final scene = CreatedScene.create(
    id: sceneID,
    name: SceneName('name'),
    genre: Genre.hobby,
    type: SceneType.alarm,
  );

  group('Alarm entity test', () {
    test("Alarm start OK test", () {
      final alarm = StartedAlarm.start(
        id: AlarmID.generate(),
        content: AlarmContent('content'),
        scene: scene,
      );

      expect(alarm.sceneID, sceneID);
      expect(alarm.isDiscarded, false);
      expect(alarm.content.value, 'content');
    });

    test("Alarm add OK test", () {
      final alarm = StartedAlarm.start(
        id: AlarmID.generate(),
        content: AlarmContent('content'),
        scene: scene,
      );

      final added = alarm.addTime(
        AlarmNotifTimeOfDay.fromNumber(12, 30),
        AlarmDayOfWeeks(const [
          DayOfWeek.friday,
          DayOfWeek.monday,
        ]),
      );

      expect(added.item1.isDiscarded, false);
      expect(added.item1.content.value, 'content');
      expect(
        added.item2.time.timeOfDay,
        AlarmNotifTimeOfDay.fromNumber(12, 30),
      );
    });

    test("Alarm add NG test", () {
      final alarm = StartedAlarm.start(
        id: AlarmID.generate(),
        content: AlarmContent('content'),
        scene: scene,
      );

      var added = alarm.addTime(
        AlarmNotifTimeOfDay.fromNumber(12, 30),
        AlarmDayOfWeeks(const [
          DayOfWeek.friday,
          DayOfWeek.monday,
        ]),
      );

      expect(() {
        for (final i in List<int>.generate(5, (i) => i)) {
          added = added.item1.addTime(
            AlarmNotifTimeOfDay.fromNumber(12, 30 + i),
            AlarmDayOfWeeks(const [
              DayOfWeek.friday,
              DayOfWeek.monday,
            ]),
          );
        }
      }, throwsA(const TypeMatcher<DomainException>()));
    });

    test("AlarmTime VO NG test", () {
      expect(() {
        AlarmNotifTimeOfDay.fromNumber(43, 30);
      }, throwsA(const TypeMatcher<DomainException>()));

      expect(() {
        AlarmNotifTimeOfDay.fromNumber(-10, 30);
      }, throwsA(const TypeMatcher<DomainException>()));

      expect(() {
        AlarmNotifTimeOfDay.fromNumber(10, -30);
      }, throwsA(const TypeMatcher<DomainException>()));

      expect(() {
        AlarmNotifTimeOfDay.fromNumber(24, 30);
      }, throwsA(const TypeMatcher<DomainException>()));
    });

    test("Alarm toggle OK test", () {
      final alarm = StartedAlarm.start(
        id: AlarmID.generate(),
        content: AlarmContent('content'),
        scene: scene,
      );

      final added = alarm.addTime(
        AlarmNotifTimeOfDay.fromNumber(12, 30),
        AlarmDayOfWeeks(const [
          DayOfWeek.friday,
          DayOfWeek.monday,
        ]),
      );

      final toggled = added.item1.toggleTimeOnOff(added.item2.time.id);

      expect(added.item2.time, toggled.item2.time);
      expect(added.item2.time.onOff != toggled.item2.time.onOff, isTrue);
    });

    test("Alarm changed and remove OK test", () {
      final alarm = StartedAlarm.start(
        id: AlarmID.generate(),
        content: AlarmContent('content'),
        scene: scene,
      );

      final added = alarm.addTime(
        AlarmNotifTimeOfDay.fromNumber(12, 30),
        AlarmDayOfWeeks(const [
          DayOfWeek.friday,
          DayOfWeek.monday,
        ]),
      );

      final changed = added.item1.changeTime(
        added.item2.time.id,
        AlarmNotifTimeOfDay.fromNumber(14, 30),
        AlarmDayOfWeeks(const [
          DayOfWeek.sunday,
          DayOfWeek.tuesday,
        ]),
      );

      expect(added.item2.time, changed.item2.time);
      expect(
          added.item2.time.timeOfDay != changed.item2.time.timeOfDay, isTrue);

      final removed = changed.item1.removeTime(added.item2.time.id);

      expect(added.item1.times.times.length != removed.item1.times.times.length,
          isTrue);
    });
  });
}
