import 'package:tasking/module/shared/domain/event.dart';

/// sync event bus class
mixin SyncEventBus {
  Map<String, Subscribers> _eventMap = {};

  /// subscribe to event
  void subscribe<E extends Event>(EventSubscriber<E> subscriber) {
    String type = E.toString();

    final subscribers = _eventMap[type];

    Subscribers addSubscribers;

    if (subscribers != null) {
      addSubscribers = subscribers;
    } else {
      addSubscribers = Subscribers<E>();
    }

    addSubscribers.add(subscriber);

    _eventMap[type] = addSubscribers;
  }

  /// remove a subscription
  void unsubscribe(EventSubscriber subscriber) {
    for (final subs in _eventMap.values) {
      subs.remove(subscriber);
    }
  }

  /// publish an event
  void publish(Event event) {
    String key = event.runtimeType.toString();

    final handleSubscribers = _eventMap[key];

    if (handleSubscribers != null) {
      handleSubscribers.handle(event);
    }
  }

  /// publishes
  void publishes(List<Event> events) {
    for (final event in events) {
      publish(event);
    }
  }

  /// remove all subscriptions
  void clear() {
    _eventMap = {};
  }
}

/// domain event bus implementation class
class SyncDomainEventBus extends DomainEventBus with SyncEventBus {}
