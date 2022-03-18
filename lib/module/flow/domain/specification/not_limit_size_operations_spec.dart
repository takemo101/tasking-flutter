import 'package:tasking/module/flow/domain/flow.dart';

// limit size operations spec
class NotLimitSizeOperationsSpec {
  bool isSatisfiedBy(Flow flow) {
    return flow.isNotLimitSizeOperations;
  }
}
