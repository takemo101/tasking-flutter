import 'package:tasking/module/alarm/domain/alarm_time_notificator.dart';
import 'package:tasking/module/alarm/domain/event/alarm_time_event.dart';

abstract class AlarmTimeEventSubscriber<T extends AlarmTimeEvent> {
  /// event handler
  Future<void> handle(T event);
}

class AlarmTimeAddedEventSubscriber
    implements AlarmTimeEventSubscriber<AlarmTimeAddedEvent> {
  final AlarmTimeNotificator notificator;

  /// constructor
  const AlarmTimeAddedEventSubscriber(this.notificator);

  @override
  Future<void> handle(AlarmTimeAddedEvent event) async {
    await notificator.make(event.content, event.time);
  }
}

class AlarmTimeChangedEventSubscriber
    implements AlarmTimeEventSubscriber<AlarmTimeChangedEvent> {
  final AlarmTimeNotificator notificator;

  /// constructor
  const AlarmTimeChangedEventSubscriber(this.notificator);

  @override
  Future<void> handle(AlarmTimeChangedEvent event) async {
    if (event.time.onOff) {
      await notificator.make(event.content, event.time);
    }
  }
}

class AlarmTimeToggledEventSubscriber
    implements AlarmTimeEventSubscriber<AlarmTimeToggledEvent> {
  final AlarmTimeNotificator notificator;

  /// constructor
  const AlarmTimeToggledEventSubscriber(this.notificator);

  @override
  Future<void> handle(AlarmTimeToggledEvent event) async {
    if (event.time.onOff) {
      await notificator.make(event.content, event.time);
    } else {
      await notificator.cancel(event.time);
    }
  }
}

class AlarmTimeRemovedEventSubscriber
    implements AlarmTimeEventSubscriber<AlarmTimeRemovedEvent> {
  final AlarmTimeNotificator notificator;

  /// constructor
  const AlarmTimeRemovedEventSubscriber(this.notificator);

  @override
  Future<void> handle(AlarmTimeRemovedEvent event) async {
    if (event.time.onOff) {
      await notificator.cancel(event.time);
    }
  }
}

class AlarmDiscardedEventSubscriber
    implements AlarmTimeEventSubscriber<AlarmDiscardedEvent> {
  final AlarmTimeNotificator notificator;

  /// constructor
  const AlarmDiscardedEventSubscriber(this.notificator);

  @override
  Future<void> handle(AlarmDiscardedEvent event) async {
    for (final time in event.times) {
      await notificator.cancel(time);
    }
  }
}

class AlarmResumedEventSubscriber
    implements AlarmTimeEventSubscriber<AlarmResumedEvent> {
  final AlarmTimeNotificator notificator;

  /// constructor
  const AlarmResumedEventSubscriber(this.notificator);

  @override
  Future<void> handle(AlarmResumedEvent event) async {
    for (final time in event.times) {
      await notificator.make(event.content, time);
    }
  }
}

class AlarmRemovedEventSubscriber
    implements AlarmTimeEventSubscriber<AlarmRemovedEvent> {
  final AlarmTimeNotificator notificator;

  /// constructor
  const AlarmRemovedEventSubscriber(this.notificator);

  @override
  Future<void> handle(AlarmRemovedEvent event) async {
    for (final time in event.times) {
      await notificator.cancel(time);
    }
  }
}
