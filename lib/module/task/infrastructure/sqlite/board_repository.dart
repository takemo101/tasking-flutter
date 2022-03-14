import 'package:tasking/module/task/domain/board.dart';
import 'package:tasking/module/task/domain/board_repository.dart';
import 'package:tasking/module/task/infrastructure/sqlite/board_repository_mapper.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:sqflite/sqflite.dart';

class BoardSQLiteRepository implements BoardRepository {
  final SQLiteHelper _helper;

  final String _table = 'pins';

  final String _taskTable = 'tasks';

  final BoardRepositoryMapper _mapper = BoardRepositoryMapper();

  BoardSQLiteRepository({required SQLiteHelper helper}) : _helper = helper;

  @override
  Future<Board> findByID(SceneID id) async {
    final executor = await _helper.executor();
    final maps = await executor.rawQuery(
      '''
        SELECT $_table.*, $_taskTable.operation_id
        FROM $_table
        INNER JOIN $_taskTable
        ON $_table.task_id = $_taskTable.id
        WHERE $_table.scene_id = ?
        ORDER BY board_order ASC
      ''',
      [id.value],
    );

    if (maps.isEmpty) {
      return Board.empty(id: id);
    }

    return _mapper.fromMapToBoard(id, maps);
  }

  @override
  Future<void> save(Board board) async {
    // all delete
    final executor = await _helper.executor();
    await executor.delete(
      _table,
      where: "scene_id = ?",
      whereArgs: [board.id.value],
    );

    final maps = _mapper.fromBoardToPinMapList(board);
    for (final map in maps) {
      await executor.insert(
        _table,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
