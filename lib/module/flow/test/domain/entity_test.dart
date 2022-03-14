import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/flow/domain/vo/operation_color.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';
import 'package:tasking/module/flow/domain/vo/reorder_operation_ids.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';

void main() {
  final id = SceneID.generate();

  group('Flow entity test', () {
    test("Flow create OK test", () {
      final flow = Flow.create(id: id);

      expect(flow.id, id);
    });

    test("Flow addOperation OK test", () {
      Flow flow = Flow.create(id: id);

      flow = flow.addOperation(
        OperationDetail(
          name: OperationName('hello1'),
          color: const OperationColor(0),
        ),
      );
      flow = flow.addOperation(
        OperationDetail(
          name: OperationName('hello2'),
          color: const OperationColor(0),
        ),
      );

      expect(flow.operations.length, 3);
    });

    test("Flow changeOperation OK test", () {
      Flow flow = Flow.create(id: id);

      flow = flow.addOperation(
        OperationDetail(
          name: OperationName('hello1'),
          color: const OperationColor(0),
        ),
      );
      flow = flow.addOperation(
        OperationDetail(
          name: OperationName('hello2'),
          color: const OperationColor(0),
        ),
      );

      final before = flow.operations.first;

      flow = flow.changeOperation(
          before.id,
          OperationDetail(
            name: OperationName('YES'),
            color: const OperationColor(1),
          ));

      final after = flow.operations.first;

      expect(before.detail.name.value != after.detail.name.value, isTrue);
    });

    test("Flow removeOperation OK test", () {
      Flow flow = Flow.create(id: id);

      flow = flow.addOperation(
        OperationDetail(
          name: OperationName('hello1'),
          color: const OperationColor(0),
        ),
      );
      final before = flow.addOperation(
        OperationDetail(
          name: OperationName('hello2'),
          color: const OperationColor(0),
        ),
      );

      final after = flow.removeOperation(flow.operations[1].id);

      expect(after.operations.length < before.operations.length, isTrue);
    });

    test("Flow reorderOperations OK test", () {
      Flow flow = Flow.create(id: id);

      flow = flow.addOperation(
        OperationDetail(
          name: OperationName('hello1'),
          color: const OperationColor(0),
        ),
      );
      final before = flow.addOperation(
        OperationDetail(
          name: OperationName('hello2'),
          color: const OperationColor(0),
        ),
      );

      List<OperationID> ids = [];

      for (final op in before.operations) {
        ids.add(op.id);
      }

      final after = before.reorderOperations(
        ReOrderOperationIDs(ids.reversed.toList()),
      );

      expect(after.operations.length, before.operations.length);
      expect(after.operations.first.id != before.operations.first.id, isTrue);
      expect(after.operations.first.id, before.operations.last.id);
    });

    test("Flow nextOperation OK test", () {
      Flow flow = Flow.create(id: id);

      flow = flow.addOperation(
        OperationDetail(
          name: OperationName('hello1'),
          color: const OperationColor(0),
        ),
      );
      flow = flow.addOperation(
        OperationDetail(
          name: OperationName('hello2'),
          color: const OperationColor(0),
        ),
      );

      final firstOperationID = flow.operations.first.id;
      final secondOperationID = flow.operations[1].id;
      final thirdOperationID = flow.operations[2].id;

      expect(
          flow.nextOperationID(firstOperationID) == secondOperationID, isTrue);
      expect(
          flow.nextOperationID(secondOperationID) == thirdOperationID, isTrue);
      expect(
          flow.nextOperationID(thirdOperationID) == firstOperationID, isTrue);
    });
  });
}
