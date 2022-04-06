import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tasking/module/alarm/domain/collection/alarm_times.dart';
import 'package:tasking/module/alarm/domain/entity/alarm_time.dart';
import 'package:tasking/module/alarm/domain/event/alarm_event.dart';
import 'package:tasking/module/alarm/domain/event/alarm_time_event.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_content.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_day_of_weeks.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_last_modified.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_notif_time_of_day.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_time_id.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/domain/aggregate_root.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/domain/type.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';

abstract class Alarm extends AggregateRoot {
  final AlarmID id;
  final AlarmContent content;
  final AlarmTimes times;
  final SceneID sceneID;
  final AlarmLastModified lastModified;

  /// private constructor
  const Alarm._({
    required this.id,
    required this.content,
    required this.times,
    required this.sceneID,
    required this.lastModified,
    List<Event> events = const <Event>[],
  }) : super(events);

  /// is discarded
  bool get isDiscarded => false;

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is Alarm && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}

/// created task class
abstract class CreatedAlarm extends Alarm {
  /// private constructor
  const CreatedAlarm._({
    required AlarmID id,
    required AlarmContent content,
    required AlarmTimes times,
    required SceneID sceneID,
    required AlarmLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super._(
          id: id,
          content: content,
          times: times,
          sceneID: sceneID,
          lastModified: lastModified,
          events: events,
        );
}

/// started alarm class
@immutable
class StartedAlarm extends CreatedAlarm {
  /// private constructor
  const StartedAlarm._({
    required AlarmID id,
    required AlarmContent content,
    required AlarmTimes times,
    required SceneID sceneID,
    required AlarmLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super._(
          id: id,
          content: content,
          times: times,
          sceneID: sceneID,
          lastModified: lastModified,
          events: events,
        );

  /// start alarm constructor
  StartedAlarm.start({
    required AlarmID id,
    required AlarmContent content,
    required Scene scene,
  }) : super._(
          id: id,
          content: content,
          times: AlarmTimes.empty(),
          sceneID: scene.id,
          lastModified: AlarmLastModified.now(),
          events: [
            StartAlarmEvent(
              id: id,
              content: content,
              sceneID: scene.id,
            )
          ],
        ) {
    if (!scene.isAlarmType) {
      throw DomainException(
        type: DomainExceptionType.specification,
        detail: "can't start the alarm due to the specifications!",
      );
    }

    times.add(
      AlarmTimeOn.create(
        timeOfDay: AlarmNotifTimeOfDay.fromNumber(12, 0),
        dayOfWeeks: AlarmDayOfWeeks(const [DayOfWeek.monday]),
      ).toggleOnOff(),
    );
  }

  /// reconstruct
  const StartedAlarm.reconstruct({
    required AlarmID id,
    required AlarmContent content,
    required AlarmTimes times,
    required SceneID sceneID,
    required AlarmLastModified lastModified,
  }) : super._(
          id: id,
          content: content,
          times: times,
          sceneID: sceneID,
          lastModified: lastModified,
        );

  /// add alarm time
  Pair<StartedAlarm, AlarmTimeAddedEvent> addTime(
    AlarmNotifTimeOfDay timeOfDay,
    AlarmDayOfWeeks dayOfWeeks,
  ) {
    final times = this.times.clone;
    final time =
        AlarmTimeOn.create(timeOfDay: timeOfDay, dayOfWeeks: dayOfWeeks);

    return Pair(
      StartedAlarm._(
        id: id,
        content: content,
        times: times..add(time),
        sceneID: sceneID,
        lastModified: AlarmLastModified.now(),
        events: recordedDomainEvent(UpdateAlarmTimeEvent(
          id: id,
          content: content,
          sceneID: sceneID,
          time: time,
        )),
      ),
      AlarmTimeAddedEvent(time: time, content: content),
    );
  }

  /// toggle alarm time on/off
  Pair<StartedAlarm, AlarmTimeToggledEvent> toggleTimeOnOff(
    AlarmTimeID timeID,
  ) {
    final times = this.times.clone;
    final time = times.toggleByID(timeID);

    return Pair(
      StartedAlarm._(
        id: id,
        content: content,
        times: times,
        sceneID: sceneID,
        lastModified: AlarmLastModified.now(),
        events: recordedDomainEvent(UpdateAlarmTimeEvent(
          id: id,
          content: content,
          sceneID: sceneID,
          time: time,
        )),
      ),
      AlarmTimeToggledEvent(time: time, content: content),
    );
  }

  /// change alarm time
  Pair<StartedAlarm, AlarmTimeChangedEvent> changeTime(
    AlarmTimeID timeID,
    AlarmNotifTimeOfDay timeOfDay,
    AlarmDayOfWeeks dayOfWeeks,
  ) {
    final times = this.times.clone;
    final time = times.changeByID(timeID, timeOfDay, dayOfWeeks);

    return Pair(
      StartedAlarm._(
        id: id,
        content: content,
        times: times,
        sceneID: sceneID,
        lastModified: AlarmLastModified.now(),
        events: recordedDomainEvent(UpdateAlarmTimeEvent(
          id: id,
          content: content,
          sceneID: sceneID,
          time: time,
        )),
      ),
      AlarmTimeChangedEvent(time: time, content: content),
    );
  }

  /// remove operation
  Pair<StartedAlarm, AlarmTimeRemovedEvent> removeTime(
    AlarmTimeID timeID,
  ) {
    final times = this.times.clone;
    final time = times.removeByID(timeID);

    return Pair(
      StartedAlarm._(
        id: id,
        content: content,
        times: times,
        sceneID: sceneID,
        lastModified: AlarmLastModified.now(),
        events: recordedDomainEvent(UpdateAlarmTimeEvent(
          id: id,
          content: content,
          sceneID: sceneID,
          time: time,
        )),
      ),
      AlarmTimeRemovedEvent(time: time),
    );
  }

  /// discard alarm
  Pair<DiscardedAlarm, AlarmDiscardedEvent> discard() {
    final times = this.times.clone;

    return Pair(
        DiscardedAlarm._(
          id: id,
          content: content,
          times: times.clone,
          sceneID: sceneID,
          lastModified: AlarmLastModified.now(),
          events: domainEvents,
        ),
        AlarmDiscardedEvent(times: times.onTimes));
  }
}

/// discarded alarm class
@immutable
class DiscardedAlarm extends CreatedAlarm {
  const DiscardedAlarm._({
    required AlarmID id,
    required AlarmContent content,
    required AlarmTimes times,
    required SceneID sceneID,
    required AlarmLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super._(
          id: id,
          content: content,
          times: times,
          sceneID: sceneID,
          lastModified: lastModified,
          events: events,
        );

  /// reconstruct
  const DiscardedAlarm.reconstruct({
    required AlarmID id,
    required AlarmContent content,
    required AlarmTimes times,
    required SceneID sceneID,
    required AlarmLastModified lastModified,
  }) : super._(
          id: id,
          content: content,
          times: times,
          sceneID: sceneID,
          lastModified: lastModified,
        );

  /// resume alarm
  Pair<StartedAlarm, AlarmResumedEvent> resume() {
    final times = this.times.clone;

    return Pair(
      StartedAlarm._(
        id: id,
        content: content,
        times: times.clone,
        sceneID: sceneID,
        lastModified: AlarmLastModified.now(),
        events: recordedDomainEvent(ResumeAlarmEvent(
          id: id,
          content: content,
          sceneID: sceneID,
        )),
      ),
      AlarmResumedEvent(times: times.onTimes, content: content),
    );
  }

  Pair<RemovedAlarm, AlarmRemovedEvent> remove() {
    final times = this.times.clone;

    return Pair(
        RemovedAlarm._(
          id: id,
          content: content,
          times: AlarmTimes.empty(),
          sceneID: sceneID,
          lastModified: lastModified,
          events: domainEvents,
        ),
        AlarmRemovedEvent(times: times.onTimes));
  }

  /// is discarded
  @override
  bool get isDiscarded => true;
}

/// removed alarm class
@immutable
class RemovedAlarm extends Alarm {
  const RemovedAlarm._({
    required AlarmID id,
    required AlarmContent content,
    required AlarmTimes times,
    required SceneID sceneID,
    required AlarmLastModified lastModified,
    List<Event> events = const <Event>[],
  }) : super._(
          id: id,
          content: content,
          times: times,
          sceneID: sceneID,
          lastModified: lastModified,
          events: events,
        );

  /// is discarded
  @override
  bool get isDiscarded => true;
}
