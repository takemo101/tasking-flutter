import 'package:tasking/module/flow/application/dto/flow_data.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';

/// flow query mapper class
class FlowQueryMapper {
  /// from map to flow dto
  FlowData fromMapToFlowData(
    SceneID id,
    List<Map<String, dynamic>> operationMaps,
  ) {
    return FlowData(
      id: 'id',
      operations: operationMaps
          .map((op) => OperationData(
                id: op['id'].toString(),
                name: op['name'].toString(),
                color: op['color'],
                order: op['flow_order'],
              ))
          .toList(),
    );
  }
}
