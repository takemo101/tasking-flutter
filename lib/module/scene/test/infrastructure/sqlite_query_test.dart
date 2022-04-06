import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/scene/domain/scene.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_name.dart';

import 'package:tasking/module/scene/infrastructure/sqlite/scene_query.dart';
import 'package:tasking/module/scene/infrastructure/sqlite/scene_repository.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';

void main() async {
  final helper = SQLiteHelper(name: 'sqlite/scene_query.sqlite');

  File file = File(helper.currentDatabasePath());
  if (file.existsSync()) {
    file.deleteSync();
  }
  file.createSync();

  await helper.open();

  SceneSQLiteRepository repository = SceneSQLiteRepository(helper: helper);
  SceneSQLiteQuery query = SceneSQLiteQuery(helper: helper);

  group('SceneSQLiteQuery test', () {
    test("SceneSQLiteQuery all", () async {
      final firstAll = await query.all();

      repository.store(
        CreatedScene.create(
          id: SceneID.generate(),
          name: SceneName('a1'),
          genre: Genre.hobby,
        ),
      );
      repository.store(
        CreatedScene.create(
          id: SceneID.generate(),
          name: SceneName('a2'),
          genre: Genre.hobby,
        ),
      );
      repository.store(
        CreatedScene.create(
          id: SceneID.generate(),
          name: SceneName('a3'),
          genre: Genre.hobby,
        ),
      );

      final all = await query.all();

      expect(all.length, firstAll.length + 3);
      expect(all.first.genre.label, 'hobby');
    });
  });
}
