import 'package:tasking/module/flow/domain/vo/operation_id.dart';
import 'package:tasking/module/task/domain/task_repository.dart';

// exists task operation specification
class ExistsTaskOperationSpec {
  final TaskRepository _repository;

  ExistsTaskOperationSpec(this._repository);

  // is exists task operation by operation id
  Future<bool> isSatisfiedBy(OperationID id) async {
    return !await _repository.existsByOperationID(id);
  }
}
