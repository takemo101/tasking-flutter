import 'package:tasking/module/flow/application/dto/flow_data.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';

/// flow query service interface
abstract class FlowQuery {
  Future<FlowData?> detail(SceneID id);
}
