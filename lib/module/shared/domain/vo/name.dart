import 'package:tasking/module/shared/domain/exception.dart';

abstract class NameString {
  final String value;

  String get name => 'name';
  int get max => 20;

  NameString(String name) : value = name.trim() {
    if (value.isEmpty) {
      throw DomainException(
        type: DomainExceptionType.notEmpty,
        detail: '$name is empty!',
      );
    }

    // name can be up to max characters
    if (value.length > max) {
      throw DomainException(
        type: DomainExceptionType.length,
        detail: '$name is too long!',
      );
    }
  }
}

abstract class Name<T extends NameString> extends NameString {
  Name(String name) : super(name);

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is T && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;
}
