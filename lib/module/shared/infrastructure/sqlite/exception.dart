/// exception for sqlite
class SQLiteException implements Exception {
  final String _message;

  SQLiteException(this._message);

  @override
  String toString() {
    return 'sqlite error: $_message';
  }
}
