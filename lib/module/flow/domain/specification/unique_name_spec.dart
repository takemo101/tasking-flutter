import 'package:tasking/module/flow/domain/entity/operation_detail.dart';
import 'package:tasking/module/flow/domain/flow.dart';

// unique name specification
class UniqueNameSpec {
  final CreatedFlow _flow;

  UniqueNameSpec(this._flow);

  // is unique operation name
  bool isSatisfiedBy(OperationDetail detail) {
    return _flow.isUniqueOperationName(detail.name);
  }
}
