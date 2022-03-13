import 'package:tasking/module/scene/application/dto/scene_data.dart';

/// scene query service interface
abstract class SceneQuery {
  Future<List<SceneData>> all();
}
