import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/event.dart';

/// aggregate root abstract class
abstract class AggregateRoot {
  final List<Event> _domainEvents;

  const AggregateRoot(List<Event> events) : _domainEvents = events;

  @protected
  List<Event> get domainEvents => [..._domainEvents];

  /// pull domain events
  List<Event> pullDomainEvents() {
    return domainEvents;
  }

  /// record domain event
  @protected
  List<Event> recordedDomainEvent(Event event) {
    final events = domainEvents;

    events.add(event);

    return events;
  }
}
