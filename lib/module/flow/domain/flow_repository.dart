import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';

abstract class FlowRepository {
  Future<CreatedFlow?> findByID(SceneID id);
  Future<void> store(CreatedFlow flow);
  Future<void> update(CreatedFlow flow);
}
