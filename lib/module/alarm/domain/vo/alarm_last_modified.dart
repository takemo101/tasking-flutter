import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/actual_time.dart';

@immutable
class AlarmLastModified extends ActualTime<AlarmLastModified> {
  AlarmLastModified(DateTime value) : super(value);
  AlarmLastModified.now() : super.now();
  AlarmLastModified.fromString(String string) : super.fromString(string);
}
