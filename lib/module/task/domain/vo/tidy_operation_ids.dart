import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/shared/domain/vo/parts.dart';

@immutable
class TidyOperationIDs extends Parts<OperationID, TidyOperationIDs> {
  TidyOperationIDs(List<OperationID> list) : super(list.reversed.toList());
}
