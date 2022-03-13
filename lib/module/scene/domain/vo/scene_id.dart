import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/identity.dart';

@immutable
class SceneID extends Identity<SceneID> {
  SceneID(String value) : super(value);
  SceneID.generate() : super.generate();
}
