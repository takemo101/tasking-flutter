import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_last_modified.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/transaction.dart';

void main() {
  SceneSQLiteRepository repository =
      SceneSQLiteRepository(helper: SQLiteHelper());
  SQLiteTransaction transaction = SQLiteTransaction(helper: SQLiteHelper());

  SQLiteHelper helper = SQLiteHelper();
  File file = File(helper.currentDatabasePath());
  file.deleteSync();
  file.createSync();

  SceneID firstID = SceneID.generate();
  SceneName firstName = SceneName('name1');

  setUp(() async {
    await helper.open();

    repository = SceneSQLiteRepository(helper: helper);
    transaction = SQLiteTransaction(helper: helper);

    repository.store(
      CreatedScene.reconstruct(
        id: firstID,
        name: firstName,
        genre: Genre.life,
        lastModified: SceneLastModified.now(),
      ),
    );
    repository.store(
      CreatedScene.reconstruct(
        id: SceneID.generate(),
        name: SceneName('name2'),
        genre: Genre.jobs,
        lastModified: SceneLastModified.now(),
      ),
    );
    repository.store(
      CreatedScene.reconstruct(
        id: SceneID.generate(),
        name: SceneName('name3'),
        genre: Genre.hobby,
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
            repository.remove(scene.remove());

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
