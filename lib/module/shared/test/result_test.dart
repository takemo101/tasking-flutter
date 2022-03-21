import 'package:flutter_test/flutter_test.dart';
import 'package:tasking/module/shared/application/result.dart';

void main() {
  setUp(() async {
    //
  });

  group('Result test', () {
    test("Result monitor success test OK", () async {
      final result = await AppResult.monitor<int, int>(() async {
        return 1;
      });

      int data = 1;

      result
        ..onSuccess((result) => data = 4)
        ..onFailure((e) => data = e);

      expect(data, 4);
    });

    test("Result monitor failure test OK", () async {
      final result = await AppResult.monitor<int, int>(() async {
        throw 3;
      });

      int data = 1;

      result
        ..onSuccess((result) => data = 4)
        ..onFailure((e) => data = e);

      expect(data, 3);
    });

    test("Result none success test OK", () async {
      final result = await AppResult.noneMonitor<int>(() async {
        //
      });

      int data = 1;

      result
        ..onSuccess((_) => data = 4)
        ..onFailure((e) => data = e);

      expect(data, 4);
    });

    test("Result none failure test OK", () async {
      final result = await AppResult.noneMonitor<int>(() async {
        throw 3;
      });

      int data = 1;

      result
        ..onSuccess((_) => data = 4)
        ..onFailure((e) => data = e);

      expect(data, 3);
    });
  });
}
