import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_last_modified.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/domain/vo/scene_type.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/transaction.dart';

void main() {
  final helper = SQLiteHelper(name: 'sqlite/database.sqlite');

  File file = File(helper.currentDatabasePath());
  if (file.existsSync()) {
    file.deleteSync();
  }
  file.createSync();

  helper.open();

  SceneSQLiteRepository repository = SceneSQLiteRepository(helper: helper);
  SQLiteTransaction transaction = SQLiteTransaction(helper: helper);

  SceneID firstID = SceneID.generate();
  SceneName firstName = SceneName('name1');

  setUp(() async {
    repository.store(
      CreatedScene.reconstruct(
        id: firstID,
        name: firstName,
        genre: Genre.life,
        type: SceneType.task,
        lastModified: SceneLastModified.now(),
      ),
    );
    repository.store(
      CreatedScene.reconstruct(
        id: SceneID.generate(),
        name: SceneName('name2'),
        genre: Genre.jobs,
        type: SceneType.task,
        lastModified: SceneLastModified.now(),
      ),
    );
    repository.store(
      CreatedScene.reconstruct(
        id: SceneID.generate(),
        name: SceneName('name3'),
        genre: Genre.hobby,
        type: SceneType.task,
        lastModified: SceneLastModified.now(),
      ),
    );
  });

  group('SQLiteTransaction test', () {
    test("SQLiteTransaction OK test", () async {
      await transaction.transaction<void>(() async {
        final scene = await repository.findByID(firstID);

        expect(scene, isNotNull);
        if (scene != null) {
          repository.remove(scene.remove());
        }
      });

      final removeScene = await repository.findByID(firstID);

      expect(removeScene, isNull);
    });

    test("SQLiteTransaction NG test", () async {
      try {
        await transaction.transaction<void>(() async {
          final scene = await repository.findByID(firstID);
          expect(scene, isNotNull);
          if (scene != null) {
            await repository.remove(scene.remove());

            throw Exception('exception');
          }
        });
      } catch (e) {
        final removeScene = await repository.findByID(firstID);
        expect(removeScene, isNotNull);
      }
    });
  });
}
