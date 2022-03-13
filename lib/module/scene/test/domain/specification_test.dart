import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/specification/unique_name_spec.dart';
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

  group('UniqueNameSpec test', () {
    test("UniqueNameSpec create test", () async {
      final spec = UniqueNameSpec(repository);

      expect(
        await spec.isSatisfiedBy(CreatedScene.create(
          id: SceneID.generate(),
          name: firstName,
          genre: Genre.hobby,
        )),
        isFalse,
      );
      expect(
        await spec.isSatisfiedBy(CreatedScene.create(
          id: SceneID.generate(),
          name: SceneName('other'),
          genre: Genre.hobby,
        )),
        isTrue,
      );
    });

    test("UniqueNameSpec update test", () async {
      final spec = UniqueNameSpec(repository);
      final scene = await repository.findByID(firstID);

      expect(scene, isNotNull);
      if (scene != null) {
        expect(await spec.isSatisfiedBy(scene), isTrue);
        expect(
            await spec.isSatisfiedBy(scene.updateContent(
              name: SceneName('name2'),
              genre: Genre.hobby,
            )),
            isFalse);
        expect(
            await spec.isSatisfiedBy(scene.updateContent(
              name: SceneName('other'),
              genre: Genre.hobby,
            )),
            isTrue);
      }
    });
  });
}
