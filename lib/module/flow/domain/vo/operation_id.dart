import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/identity.dart';

@immutable
class OperationID extends Identity<OperationID> {
  OperationID(String value) : super(value);
  OperationID.generate() : super.generate();
}
