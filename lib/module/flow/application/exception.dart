import 'package:tasking/module/shared/application/exception.dart';

class NotUniqueOperationNameException extends ApplicationException {
  NotUniqueOperationNameException()
      : super(detail: 'not unique operation name!');
}
