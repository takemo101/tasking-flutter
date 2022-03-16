/// exception for application
abstract class ApplicationException implements Exception {
  final String detail;
  final String? jp;

  ApplicationException({
    required this.detail,
    this.jp,
  });

  @override
  String toString() {
    return 'application error: $detail';
  }

  String toJP() {
    return jp == null || jp!.isEmpty ? toString() : jp!;
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
