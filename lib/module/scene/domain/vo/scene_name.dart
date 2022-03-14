import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/name.dart';

@immutable
class SceneName extends Name<SceneName> {
  SceneName(String name) : super(name);

  @override
  int get max => 60;

  @override
  String get label => 'scene name';
}
