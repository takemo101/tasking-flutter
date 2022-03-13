import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/infrastructure/uuid.dart';

abstract class UUID {
  final String value;

  /// constructor
  UUID(this.value) {
    if (value.isEmpty) {
      throw DomainException(
        type: DomainExceptionType.notEmpty,
        detail: 'id is empty!',
      );
    }
  }

  /// generate id constructor
  UUID.generate() : this(generateUUID());
}

abstract class Identity<T extends UUID> extends UUID {
  Identity(String value) : super(value);
  Identity.generate() : super.generate();

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is T && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;
}
