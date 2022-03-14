import 'package:meta/meta.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/shared/domain/vo/parts.dart';

@immutable
class ReOrderOperationIDs extends Parts<OperationID, ReOrderOperationIDs> {
  ReOrderOperationIDs(List<OperationID> list) : super(list);

  ReOrderOperationIDs.fromStringList(List<String> strings)
      : this(
          strings.map<OperationID>((s) => OperationID(s)).toList(),
        );
}
