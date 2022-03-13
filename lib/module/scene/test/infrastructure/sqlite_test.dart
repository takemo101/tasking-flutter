import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_last_modified.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';

void main() {
  SceneSQLiteRepository repository =
      SceneSQLiteRepository(helper: SQLiteHelper());

  SQLiteHelper helper = SQLiteHelper();
  File file = File(helper.currentDatabasePath());
  file.deleteSync();
  file.createSync();

  SceneID firstID = SceneID.generate();
  SceneName firstName = SceneName('name1');

  setUp(() async {
    await helper.open();

    repository = SceneSQLiteRepository(helper: helper);

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

  group('SQLiteRepository test', () {
    test("SQLiteRepository findByID test", () async {
      final scene = await repository.findByID(firstID);
      expect(scene, isNotNull);
      if (scene != null) {
        expect(scene.id.value, firstID.value);
      }
    });

    test("SQLiteRepository listByName test", () async {
      final result = await repository.listByName(firstName);
      expect(result.length, 1);
    });

    test("SQLiteRepository update test", () async {
      final scene = await repository.findByID(firstID);
      expect(scene != null, isTrue);

      if (scene != null) {
        await repository.update(scene.updateContent(
          name: SceneName('first'),
          genre: Genre.hobby,
        ));

        final updateScene = await repository.findByID(firstID);
        expect(updateScene != null, isTrue);

        if (updateScene != null) {
          expect(scene.name != updateScene.name, isTrue);
          expect(scene.genre != updateScene.genre, isTrue);
          expect(scene.lastModified != updateScene.lastModified, isTrue);
        }
      }
    });

    test("SQLiteRepository remove test", () async {
      final scene = await repository.findByID(firstID);

      expect(scene, isNotNull);
      if (scene != null) {
        await repository.remove(scene.remove());
      }

      final after = await repository.findByID(firstID);
      expect(after, isNull);
    });
  });
}
