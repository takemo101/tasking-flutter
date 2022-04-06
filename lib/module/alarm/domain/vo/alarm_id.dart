import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/identity.dart';

@immutable
class AlarmID extends Identity<AlarmID> {
  AlarmID(String value) : super(value);
  AlarmID.generate() : super.generate();
}
