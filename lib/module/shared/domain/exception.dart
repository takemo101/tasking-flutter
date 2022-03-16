/// exception for domain
class DomainException implements Exception {
  final DomainExceptionType type;
  final String detail;
  final String? jp;

  DomainException({
    this.type = DomainExceptionType.unknown,
    required this.detail,
    this.jp,
  });

  bool hasType(DomainExceptionType t) {
    return type == t;
  }

  @override
  String toString() {
    return '${type.message}: $detail';
  }

  String toJP() {
    return jp == null || jp!.isEmpty ? toString() : jp!;
  }
}

/// domain exception type enum
enum DomainExceptionType {
  notFound,
  notEmpty,
  notMatch,
  duplicate,
  number,
  length,
  size,
  datetime,
  specification,
  unknown,
}

/// exception message extension
extension ExceptionTypeMessage on DomainExceptionType {
  String get message {
    switch (this) {
      case DomainExceptionType.notFound:
        return 'not found error';
      case DomainExceptionType.notEmpty:
        return 'not empty error';
      case DomainExceptionType.notMatch:
        return 'not match error';
      case DomainExceptionType.duplicate:
        return 'duplicate error';
      case DomainExceptionType.number:
        return 'invalid number error';
      case DomainExceptionType.length:
        return 'invalid length error';
      case DomainExceptionType.size:
        return 'invalid size error';
      case DomainExceptionType.datetime:
        return 'invalid datetime error';
      case DomainExceptionType.specification:
        return 'specification error';
      case DomainExceptionType.unknown:
      default:
        return 'unknown error';
    }
  }
}
