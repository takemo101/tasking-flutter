import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/actual_time.dart';

@immutable
class SceneLastModified extends ActualTime<SceneLastModified> {
  SceneLastModified(DateTime value) : super(value);
  SceneLastModified.now() : super.now();
  SceneLastModified.fromString(String string) : super.fromString(string);
}
