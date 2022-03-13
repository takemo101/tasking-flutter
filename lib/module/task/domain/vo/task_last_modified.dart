import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/actual_time.dart';

@immutable
class TaskLastModified extends ActualTime<TaskLastModified> {
  TaskLastModified(DateTime value) : super(value);
  TaskLastModified.now() : super.now();
  TaskLastModified.fromString(String string) : super.fromString(string);
}
