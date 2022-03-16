import 'package:tasking/module/shared/application/exception.dart';

class NotUniqueOperationNameException extends ApplicationException {
  NotUniqueOperationNameException()
      : super(
          detail: 'not unique operation name!',
          jp: 'オペレーションネームが重複しています！',
        );
}

class LimitSizeOperationsException extends ApplicationException {
  LimitSizeOperationsException()
      : super(
          detail: 'limit size operations!',
          jp: 'これ以上オペレーションを追加できません！',
        );
}

class ExistsTaskOperationException extends ApplicationException {
  ExistsTaskOperationException()
      : super(
          detail: 'task operation exists!',
          jp: 'オペレーションが割り当てられているタスクが存在しています！',
        );
}
