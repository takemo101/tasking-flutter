import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/infrastructure/event.dart';

String data = '';

void main() {
  EventBus bus = SyncDomainEventBus();
  ASubscriber subscriber = ASubscriber();

  setUp(() async {
    data = 'init';

    bus.clear();

    bus.subscribe<AEvent>(subscriber);
  });

  group('Event test', () {
    test("Event publish OK test", () {
      bus.publish(AEvent('A'));
      bus.publish(AEvent('E1'));
      bus.publish(AEvent('D2'));
      bus.publish(AEvent('C3'));
      bus.publish(AEvent('E4'));
      bus.publish(AEvent('D5'));
      bus.publish(AEvent('C6'));
      bus.publish(AEvent('A'));

      expect(
        data,
        'A',
      );
    });

    test("Event publish NG test", () {
      bus.publish(BEvent('B'));

      expect(
        data == 'B',
        isFalse,
      );
    });

    test("Event subscribe OK test", () async {
      bus.subscribe(BSubscriber());

      bus.publish(BEvent('B'));

      expect(
        data,
        'B',
      );
    });

    test("Event unsubscribe OK test", () async {
      bus.unsubscribe(subscriber);

      bus.publish(AEvent('A'));

      expect(
        data == 'A',
        isFalse,
      );
    });
  });
}

class AEvent implements Event {
  final String text;

  AEvent(
    this.text,
  );
}

class BEvent implements Event {
  final String text;

  BEvent(
    this.text,
  );
}

class ASubscriber implements EventSubscriber<AEvent> {
  @override
  void handle(AEvent event) async {
    data = event.text;
  }
}

class BSubscriber implements EventSubscriber<BEvent> {
  @override
  void handle(BEvent event) async {
    data = event.text;
  }
}
