import 'package:flutter/foundation.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/application/query/scene_query.dart';
import 'package:tasking/module/scene/application/usecase/create_scene_usecase.dart';
import 'package:tasking/module/scene/application/usecase/remove_scene_usecase.dart';
import 'package:tasking/module/scene/application/usecase/scene_list_usecase.dart';
import 'package:tasking/module/scene/application/usecase/update_scene_usecase.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

class SceneNotifier extends ChangeNotifier {
  final CreateSceneUseCase _createUseCase;
  final UpdateSceneUseCase _updateUseCase;
  final RemoveSceneUseCase _removeUseCase;
  final SceneListUseCase _listUseCase;

  List<SceneData> _list = <SceneData>[];

  List<SceneData> get list => List.unmodifiable(_list);

  SceneNotifier({
    required SceneRepository repository,
    required SceneQuery query,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _createUseCase = CreateSceneUseCase(
          repository: repository,
          transaction: transaction,
          eventBus: eventBus,
        ),
        _updateUseCase = UpdateSceneUseCase(
          repository: repository,
          transaction: transaction,
        ),
        _removeUseCase = RemoveSceneUseCase(
          repository: repository,
          transaction: transaction,
        ),
        _listUseCase = SceneListUseCase(query: query);

  Future<void> create({
    required String name,
    required String genre,
  }) async {
    await _createUseCase.execute(
      CreateSceneCommand(
        name: name,
        genre: genre,
      ),
    );

    listUpdate();
  }

  Future<void> update({
    required String id,
    required String name,
    required String genre,
  }) async {
    await _updateUseCase.execute(
      UpdateSceneCommand(
        id: id,
        name: name,
        genre: genre,
      ),
    );

    listUpdate();
  }

  Future<void> remove(String id) async {
    await _removeUseCase.execute(id);

    listUpdate();
  }

  void listUpdate() {
    _listUseCase.execute().then((list) {
      _list = list;
      notifyListeners();
    });
  }
}
