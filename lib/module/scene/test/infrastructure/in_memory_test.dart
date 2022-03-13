import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_last_modified.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';
import 'package:tasking/module/scene/infrastructure/in_memory/scene_repository.dart';

void main() {
  SceneInMemoryRepository repository = SceneInMemoryRepository();

  SceneID firstID = SceneID.generate();
  SceneName firstName = SceneName('name1');

  setUp(() {
    repository = SceneInMemoryRepository();

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

  group('inMemoryRepository test', () {
    test("inMemoryRepository findByID test", () async {
      final scene = await repository.findByID(firstID);
      expect(scene, isNotNull);
      if (scene != null) {
        expect(scene.id.value, firstID.value);
      }
    });

    test("inMemoryRepository listByName test", () async {
      final result = await repository.listByName(firstName);
      expect(result.length, 1);
    });

    test("inMemoryRepository update test", () async {
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

    test("inMemoryRepository remove test", () async {
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
