import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';

abstract class FlowRepository {
  Future<Flow?> findByID(SceneID id);
  Future<void> save(Flow flow);
}
