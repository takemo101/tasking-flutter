import 'package:tasking/module/shared/application/exception.dart';

class NotUniqueSceneNameException extends ApplicationException {
  NotUniqueSceneNameException() : super(detail: 'not unique scene name!');
}
