import 'package:meta/meta.dart';
import 'package:tasking/module/alarm/domain/entity/alarm_time.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_content.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/domain/event.dart';

/// abstract alarm event
abstract class AlarmEvent implements Event {
  final AlarmID id;
  final AlarmContent content;
  final SceneID sceneID;

  const AlarmEvent({
    required this.id,
    required this.content,
    required this.sceneID,
  });
}

/// start alarm event
@immutable
class StartAlarmEvent extends AlarmEvent {
  const StartAlarmEvent({
    required AlarmID id,
    required AlarmContent content,
    required SceneID sceneID,
  }) : super(
          id: id,
          content: content,
          sceneID: sceneID,
        );
//
}

/// resume alarm event
@immutable
class ResumeAlarmEvent extends AlarmEvent {
  const ResumeAlarmEvent({
    required AlarmID id,
    required AlarmContent content,
    required SceneID sceneID,
  }) : super(
          id: id,
          content: content,
          sceneID: sceneID,
        );
}

/// update alarm time event
@immutable
class UpdateAlarmTimeEvent implements Event {
  final AlarmID id;
  final AlarmContent content;
  final AlarmTime time;
  final SceneID sceneID;

  const UpdateAlarmTimeEvent({
    required this.id,
    required this.content,
    required this.time,
    required this.sceneID,
  });
}
