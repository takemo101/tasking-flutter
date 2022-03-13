import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/scene/domain/vo/genre.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/domain/vo/scene_last_modified.dart';
import 'package:tasking/module/shared/domain/exception.dart';

void main() {
  final firstID = SceneID.generate();
  final firstTime = SceneLastModified.now();
  group('ValueObject test', () {
    test("SceneID OK test", () {
      final sceneID = SceneID(firstID.value);
      expect(firstID, sceneID);
    });

    test("SceneID NG test", () {
      final sceneID = SceneID.generate();
      expect(firstID == sceneID, isFalse);
    });

    test("SceneLastModified OK test", () {
      final lastModified = SceneLastModified(firstTime.value);
      expect(firstTime, lastModified);
    });

    test("SceneLastModified NG test", () {
      final lastModified = SceneLastModified.now();
      expect(firstTime == lastModified, isFalse);
    });

    test("SceneLastModified Exception test", () {
      expect(() {
        SceneLastModified(DateTime.now().add(const Duration(days: 1)));
      }, throwsA(const TypeMatcher<DomainException>()));
    });

    test("Genre create OK test", () {
      final genre = GenreName.fromName('life');
      expect(Genre.life, genre);
    });
  });
}
