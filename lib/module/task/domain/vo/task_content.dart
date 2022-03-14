import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/name.dart';

@immutable
class TaskContent extends Name<TaskContent> {
  TaskContent(String name) : super(name);

  @override
  int get max => 120;

  @override
  String get label => 'content';
}
