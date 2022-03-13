abstract class Transaction {
  Future<T> transaction<T>(Future<T> Function() f);
}
