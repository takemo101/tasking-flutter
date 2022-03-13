/// event dto interface
abstract class Event {}

/// event subscriber interface
abstract class EventSubscriber<E extends Event> {
  /// handle event
  void handle(E event);
}

/// subscriber collection class
class Subscribers<E extends Event> {
  final List<EventSubscriber<E>> _subscribers = <EventSubscriber<E>>[];

  Subscribers();

  void add(EventSubscriber<E> subscriber) {
    _subscribers.add(subscriber);
  }

  void remove(EventSubscriber subscriber) {
    _subscribers.removeWhere((sub) => sub == subscriber);
  }

  void handle(E event) async {
    for (final subscriber in _subscribers) {
      subscriber.handle(event);
    }
  }

  List<EventSubscriber> get asList => [..._subscribers];
}

/// event bus interface
abstract class EventBus {
  /// subscribe to event
  void subscribe<E extends Event>(EventSubscriber<E> subscriber);

  /// remove a subscription
  void unsubscribe(EventSubscriber subscriber);

  /// publish an event
  void publish(Event event);

  /// publishes
  void publishes(List<Event> events);

  /// remove all subscriptions
  void clear();
}

/// domain event bus interface
abstract class DomainEventBus implements EventBus {
  //
}
