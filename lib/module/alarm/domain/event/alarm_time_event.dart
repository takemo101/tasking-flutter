import 'package:meta/meta.dart';
import 'package:tasking/module/alarm/domain/entity/alarm_time.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_content.dart';

abstract class AlarmTimeEvent {
  //
}

/// alarm time added event
@immutable
class AlarmTimeAddedEvent implements AlarmTimeEvent {
  final AlarmTimeOn time;
  final AlarmContent content;

  const AlarmTimeAddedEvent({
    required this.time,
    required this.content,
  });
}

/// alarm time changed event
@immutable
class AlarmTimeChangedEvent implements AlarmTimeEvent {
  final AlarmTime time;
  final AlarmContent content;

  const AlarmTimeChangedEvent({
    required this.time,
    required this.content,
  });
}

/// alarm time toggled event
@immutable
class AlarmTimeToggledEvent implements AlarmTimeEvent {
  final AlarmTime time;
  final AlarmContent content;

  const AlarmTimeToggledEvent({
    required this.time,
    required this.content,
  });
}

/// alarm time removed event
@immutable
class AlarmTimeRemovedEvent implements AlarmTimeEvent {
  final AlarmTime time;

  const AlarmTimeRemovedEvent({
    required this.time,
  });
}

/// alarm time discarded event
@immutable
class AlarmDiscardedEvent implements AlarmTimeEvent {
  final List<AlarmTimeOn> times;

  const AlarmDiscardedEvent({
    required this.times,
  });
}

/// alarm time resumed event
@immutable
class AlarmResumedEvent implements AlarmTimeEvent {
  final List<AlarmTimeOn> times;
  final AlarmContent content;

  const AlarmResumedEvent({
    required this.times,
    required this.content,
  });
}

/// alarm time removed event
@immutable
class AlarmRemovedEvent implements AlarmTimeEvent {
  final List<AlarmTimeOn> times;

  const AlarmRemovedEvent({
    required this.times,
  });
}
