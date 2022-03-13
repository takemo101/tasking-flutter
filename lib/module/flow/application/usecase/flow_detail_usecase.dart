import 'package:tasking/module/flow/application/dto/flow_data.dart';
import 'package:tasking/module/flow/application/query/flow_query.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';

/// flow detail usecase
class FlowDetailUseCase {
  final FlowQuery _query;

  FlowDetailUseCase({
    required FlowQuery query,
  }) : _query = query;

  Future<FlowData> execute(String id) async {
    final flow = await _query.detail(SceneID(id));

    if (flow == null) {
      throw NotFoundException(id, name: 'flow');
    }

    return flow;
  }
}
