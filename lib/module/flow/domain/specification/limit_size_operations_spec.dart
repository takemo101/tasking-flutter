import 'package:tasking/module/flow/domain/flow.dart';

// limit size operations spec
class LimitSizeOperationsSpec {
  bool isSatisfiedBy(Flow flow) {
    return flow.isLimitSizeOperations;
  }
}
