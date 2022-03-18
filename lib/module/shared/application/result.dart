import 'package:meta/meta.dart';

// abstract app result
abstract class AppResult<T, E extends Exception> {
  // is success
  bool get isSuccess => this is SuccessResult<T, E>;

  // is failure
  bool get isFailure => this is FailureResult<T, E>;

  // is error
  bool get isError => this is ErrorResult<T, E>;

  // successful results
  T get result {
    if (this is SuccessResult<T, E>) {
      return (this as SuccessResult<T, E>)._result;
    }

    throw Exception(
      'the result is a failure and cannot be accessed',
    );
  }

  void onSuccess(Function(T) callback) {
    //
  }

  void onFailure(Function(E) callback) {
    //
  }

  void onError(Function(Object) callback) {
    //
  }

  void exception() {
    //
  }

  // listen exception
  static Future<AppResult<S, F>> listen<S, F extends Exception>(
      Future<S> Function() callback,
      [bool catchError = true]) async {
    if (catchError) {
      try {
        return SuccessResult(await callback());
      } on F catch (e) {
        return FailureResult(e);
      } catch (e) {
        return ErrorResult(e);
      }
    } else {
      try {
        return SuccessResult(await callback());
      } on F catch (e) {
        return FailureResult(e);
      }
    }
  }
}

// success results class
@immutable
class SuccessResult<T, E extends Exception> extends AppResult<T, E> {
  final T _result;

  SuccessResult(T result) : _result = result;

  @override
  void onSuccess(Function(T) callback) {
    callback(_result);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SuccessResult<T, E> && other._result == _result;
  }

  @override
  int get hashCode => _result.hashCode;

  @override
  String toString() => 'success: $_result';
}

// failure result class
@immutable
class FailureResult<T, E extends Exception> extends AppResult<T, E> {
  final E _error;

  FailureResult(E error) : _error = error;

  @override
  void onFailure(Function(E) callback) {
    callback(_error);
  }

  @override
  void exception() {
    throw _error;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FailureResult<T, E> && other._error == _error;
  }

  @override
  int get hashCode => _error.hashCode;

  @override
  String toString() => 'failure: $_error';
}

// error result class
@immutable
class ErrorResult<T, E extends Exception> extends AppResult<T, E> {
  final Object _error;

  ErrorResult(Object error) : _error = error;

  @override
  void onError(Function(Object) callback) {
    callback(_error);
  }

  @override
  void exception() {
    throw _error;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FailureResult<T, E> && other._error == _error;
  }

  @override
  int get hashCode => _error.hashCode;

  @override
  String toString() => 'error: $_error';
}
