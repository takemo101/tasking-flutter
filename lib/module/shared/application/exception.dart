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
    String? jp,
  }) : super(
          detail: 'not found [id = $id] entity',
          jp: jp,
        );
}
