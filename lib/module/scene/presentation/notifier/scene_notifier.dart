import 'package:flutter/foundation.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/application/query/scene_query.dart';
import 'package:tasking/module/scene/application/usecase/create_scene_usecase.dart';
import 'package:tasking/module/scene/application/usecase/remove_scene_usecase.dart';
import 'package:tasking/module/scene/application/usecase/scene_list_usecase.dart';
import 'package:tasking/module/scene/application/usecase/update_scene_usecase.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
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

  Future<AppResult<SceneID, ApplicationException>> create({
    required String name,
    required String genre,
  }) async {
    return await _createUseCase.execute(
      CreateSceneCommand(
        name: name,
        genre: genre,
      ),
    )
      ..onSuccess((_) => listUpdate());
  }

  Future<AppResult<SceneID, ApplicationException>> update({
    required String id,
    required String name,
    required String genre,
  }) async {
    return await _updateUseCase.execute(
      UpdateSceneCommand(
        id: id,
        name: name,
        genre: genre,
      ),
    )
      ..onSuccess((_) => listUpdate());
  }

  Future<AppResult<SceneID, ApplicationException>> remove(String id) async {
    return await _removeUseCase.execute(id)
      ..onSuccess((_) => listUpdate());
  }

  void listUpdate() {
    _listUseCase.execute().then((result) {
      result.onSuccess((list) {
        _list = list;
        notifyListeners();
      });
    });
  }
}
