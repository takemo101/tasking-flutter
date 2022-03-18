import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';

// unique name specification
class UniqueNameSpec {
  final OperationDetail _detail;
  final OperationID? _operationID;

  UniqueNameSpec(OperationDetail detail, [OperationID? operationID])
      : _detail = detail,
        _operationID = operationID;

  // is unique operation name
  bool isSatisfiedBy(Flow flow) {
    return flow.isUniqueOperationName(_detail.name, _operationID);
  }
}
