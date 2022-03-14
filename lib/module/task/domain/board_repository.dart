import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/task/domain/board.dart';

abstract class BoardRepository {
  Future<Board> findByID(SceneID id);
  Future<void> save(Board board);
}
