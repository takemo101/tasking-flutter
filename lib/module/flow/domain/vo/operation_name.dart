import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/name.dart';

@immutable
class OperationName extends Name<OperationName> {
  OperationName(String name) : super(name);

  @override
  int get max => 30;
}
