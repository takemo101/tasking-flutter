import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/alarm/domain/alarm.dart';
import 'package:tasking/module/alarm/domain/collection/alarm_times.dart';
import 'package:tasking/module/alarm/domain/entity/alarm_time.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_content.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_day_of_weeks.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_last_modified.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_notif_time_of_day.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_time_id.dart';
import 'package:tasking/module/alarm/intrastracture/sqlite/alarm_repository.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_last_modified.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/domain/vo/scene_type.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';

void main() async {
  final helper = SQLiteHelper(name: 'sqlite/alarm_repository.sqlite');

  File file = File(helper.currentDatabasePath());
  if (file.existsSync()) {
    file.deleteSync();
  }
  file.createSync();

  helper.open();

  AlarmSQLiteRepository repository = AlarmSQLiteRepository(helper: helper);

  SceneSQLiteRepository sceneRepository = SceneSQLiteRepository(helper: helper);

  SceneID sceneID = SceneID.generate();

  AlarmID alarmID = AlarmID.generate();

  await sceneRepository.store(
    CreatedScene.reconstruct(
      id: sceneID,
      name: SceneName('sc1'),
      genre: Genre.jobs,
      type: SceneType.task,
      lastModified: SceneLastModified.now(),
    ),
  );

  await repository.store(
    StartedAlarm.reconstruct(
      id: alarmID,
      content: AlarmContent('content'),
      times: AlarmTimes([
        AlarmTime.reconstruct(true,
            id: AlarmTimeID.generate(),
            timeOfDay: AlarmNotifTimeOfDay.fromNumber(11, 0),
            dayOfWeeks: AlarmDayOfWeeks.fromIndexes(const [0, 1, 2, 3]))
      ]),
      sceneID: sceneID,
      lastModified: AlarmLastModified.now(),
    ),
  );

  group('AlarmSQLiteRepository test', () {
    test("AlarmSQLiteRepository store and findByID test", () async {
      final id = AlarmID.generate();
      final content = AlarmContent('test');

      await repository.store(
        StartedAlarm.reconstruct(
          id: id,
          content: content,
          times: AlarmTimes([
            AlarmTime.reconstruct(true,
                id: AlarmTimeID.generate(),
                timeOfDay: AlarmNotifTimeOfDay.fromNumber(11, 030),
                dayOfWeeks: AlarmDayOfWeeks.fromIndexes(const [0, 1, 2, 3]))
          ]),
          sceneID: sceneID,
          lastModified: AlarmLastModified.now(),
        ),
      );

      final alarm = await repository.findStartedByID(id);

      expect(alarm, isNotNull);
      if (alarm != null) {
        expect(alarm.id, id);
        expect(alarm.content, content);
      }
    });

    test("AlarmSQLiteRepository discard and resume,remove test", () async {
      final id = AlarmID.generate();
      final content = AlarmContent('test');

      await repository.store(
        StartedAlarm.reconstruct(
          id: id,
          content: content,
          times: AlarmTimes([
            AlarmTime.reconstruct(true,
                id: AlarmTimeID.generate(),
                timeOfDay: AlarmNotifTimeOfDay.fromNumber(11, 030),
                dayOfWeeks: AlarmDayOfWeeks.fromIndexes(const [0, 1, 2, 3]))
          ]),
          sceneID: sceneID,
          lastModified: AlarmLastModified.now(),
        ),
      );

      final alarm = await repository.findStartedByID(id);

      expect(alarm, isNotNull);
      if (alarm != null) {
        final discarded = alarm.discard();
        await repository.update(discarded.item1);

        final findDiscadedStarted = await repository.findStartedByID(id);
        expect(findDiscadedStarted, isNull);

        final findDiscardedDiscarded = await repository.findDiscardedByID(id);

        expect(findDiscardedDiscarded, isNotNull);
        if (findDiscardedDiscarded != null) {
          final resumed = findDiscardedDiscarded.resume();
          await repository.update(resumed.item1);

          final findStartedDiscarded = await repository.findDiscardedByID(id);
          expect(findStartedDiscarded, isNull);

          final findStartedStarted = await repository.findStartedByID(id);
          expect(findStartedStarted, isNotNull);
          if (findStartedStarted != null) {
            final removed = findStartedStarted.discard().item1.remove();
            await repository.remove(removed.item1);

            final findRemovedDiscarded = await repository.findDiscardedByID(id);
            expect(findRemovedDiscarded, isNull);

            final findRemovedStarted = await repository.findStartedByID(id);
            expect(findRemovedStarted, isNull);
          }
        }
      }
    });

    test("AlarmSQLiteRepository addTime,changeTime,toggleTime test", () async {
      final id = AlarmID.generate();
      final content = AlarmContent('test');

      await repository.store(
        StartedAlarm.reconstruct(
          id: id,
          content: content,
          times: AlarmTimes([
            AlarmTime.reconstruct(true,
                id: AlarmTimeID.generate(),
                timeOfDay: AlarmNotifTimeOfDay.fromNumber(11, 030),
                dayOfWeeks: AlarmDayOfWeeks.fromIndexes(const [0, 1, 2, 3]))
          ]),
          sceneID: sceneID,
          lastModified: AlarmLastModified.now(),
        ),
      );

      final alarm = await repository.findStartedByID(id);

      expect(alarm, isNotNull);
      if (alarm != null) {
        final beforeLength = alarm.times.times.length;

        final addTimeAlarm = alarm.addTime(
          AlarmNotifTimeOfDay.fromNumber(12, 30),
          AlarmDayOfWeeks.fromIndexes(const [0, 1, 2, 3]),
        );

        final timeID = addTimeAlarm.item2.time.id;

        await repository.update(addTimeAlarm.item1);

        final added = await repository.findStartedByID(id);

        expect(added, isNotNull);
        if (added != null) {
          expect(added.times.times.length, beforeLength + 1);

          final changeTimeOfDay = AlarmNotifTimeOfDay.fromNumber(14, 30);
          final changeTimeAlarm = added.changeTime(
            timeID,
            changeTimeOfDay,
            AlarmDayOfWeeks.fromIndexes(const [0, 1, 2, 3]),
          );

          await repository.update(changeTimeAlarm.item1);

          final changed = await repository.findStartedByID(id);

          expect(changed, isNotNull);
          if (changed != null) {
            expect(changed.times.times.last.id, timeID);
            expect(changed.times.times.last.timeOfDay, changeTimeOfDay);

            final beforeOnOff = changed.times.times.last.onOff;

            final toggledTimeAlarm = changed.toggleTimeOnOff(timeID);

            await repository.update(toggledTimeAlarm.item1);

            final toggled = await repository.findStartedByID(id);

            expect(toggled, isNotNull);
            if (toggled != null) {
              expect(toggled.times.times.last.id, timeID);
              expect(toggled.times.times.last.onOff != beforeOnOff, isTrue);

              final removeTimeAlarm = changed.removeTime(timeID);

              await repository.update(removeTimeAlarm.item1);

              final removed = await repository.findStartedByID(id);

              expect(removed, isNotNull);
              if (removed != null) {
                expect(removed.times.times.length, beforeLength);

                expect(() {
                  removed.changeTime(
                    timeID,
                    changeTimeOfDay,
                    AlarmDayOfWeeks.fromIndexes(const [0, 1, 2, 3]),
                  );
                }, throwsA(const TypeMatcher<DomainException>()));
              }
            }
          }
        }
      }
    });
  });
}
