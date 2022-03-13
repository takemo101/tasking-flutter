import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/identity.dart';

@immutable
class TaskID extends Identity<TaskID> {
  TaskID(String value) : super(value);
  TaskID.generate() : super.generate();
}
