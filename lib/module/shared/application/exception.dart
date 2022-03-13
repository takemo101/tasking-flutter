/// exception for application
abstract class ApplicationException implements Exception {
  final String detail;

  ApplicationException({
    required this.detail,
  });

  @override
  String toString() {
    return 'application error: $detail';
  }
}

/// not found exception
class NotFoundException extends ApplicationException {
  NotFoundException(
    String id, {
    String name = '',
  }) : super(
          detail: name.isEmpty
              ? 'not found [id = $id] entity'
              : 'not found [id = $id] $name entity',
        );
}
