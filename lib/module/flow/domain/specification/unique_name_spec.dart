import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/flow.dart';
import 'package:tasking/module/flow/domain/vo/operation_id.dart';

// unique name specification
class UniqueNameSpec {
  final Flow _flow;

  UniqueNameSpec(Flow flow) : _flow = flow;

  // is unique operation name
  bool isSatisfiedBy(OperationDetail detail, [OperationID? operationID]) {
    return _flow.isUniqueOperationName(detail.name, operationID);
  }
}
