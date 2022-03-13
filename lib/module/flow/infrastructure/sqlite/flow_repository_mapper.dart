import 'package:tasking/module/flow/domain/entity/operation.dart';
import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/flow/domain/vo/flow_order.dart';
import 'package:tasking/module/flow/domain/vo/operation_color.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/flow/domain/vo/operation_name.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';

/// flow repository mapper class
class FlowRepositoryMapper {
  /// from created flow to map
  Map<String, dynamic> fromCreatedFlowToMap(CreatedFlow flow) {
    return {
      'id': flow.id.value,
    };
  }

  /// from created flow to operation map list
  List<Map<String, dynamic>> fromCreatedFlowToOperationMapList(
    CreatedFlow flow,
  ) {
    List<Map<String, dynamic>> result = [];

    for (final operation in flow.operations) {
      result.add(
        fromOperationToMap(flow.id, operation),
      );
    }

    return result;
  }

  /// from operation to map
  Map<String, dynamic> fromOperationToMap(
    SceneID id,
    Operation operation,
  ) {
    return {
      'id': operation.id.value,
      'scene_id': id.value,
      'name': operation.detail.name.value,
      'color': operation.detail.color.value,
      'flow_order': operation.order.value,
    };
  }

  /// from map to created flow aggregate
  CreatedFlow fromMapToCreatedFlow(
    SceneID id,
    List<Map<String, dynamic>> operationMaps,
  ) {
    return CreatedFlow.reconstruct(
      id: id,
      operations: operationMaps
          .map((op) => Operation.reconstruct(
                id: OperationID(op['id'].toString()),
                order: FlowOrder(op['flow_order']),
                detail: OperationDetail(
                  name: OperationName(op['name'].toString()),
                  color: OperationColor(op['color']),
                ),
              ))
          .toList(),
    );
  }
}
