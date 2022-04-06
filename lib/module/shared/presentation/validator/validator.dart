/// validator class
abstract class Validatable<T> {
  String? Function(T) get validate;

  bool isValid(T value) {
    return validate(value) == null;
  }
}

/// multiple validator class
class Validators<T> {
  final List<Validatable<T>> validators;

  Validators(this.validators);

  static String? Function(E) to<E>(List<Validatable<E>> validators) {
    return Validators<E>(validators).validate;
  }

  /// validate everything
  String? validate(T value) {
    for (final validator in validators) {
      final valid = validator.validate(value);
      if (valid != null) {
        return valid;
      }
    }

    return null;
  }

  bool isValid(T value) {
    return validate(value) == null;
  }
}

/// exception for validator
class ValidatorException implements Exception {
  final String detail;

  ValidatorException({
    required this.detail,
  });

  @override
  String toString() {
    return 'validator error: $detail';
  }
}

/// for name validator
class NameValidator extends Validatable<String?> {
  final String name;
  final int max;

  NameValidator({
    required this.name,
    required this.max,
  }) {
    if (max < 0) {
      throw ValidatorException(detail: 'max number is invalid');
    }
  }

  @override
  String? Function(String?) get validate => (value) {
        if (value == null) {
          return '$nameが空です！';
        }

        if (value.isEmpty) {
          return '$nameを入力してください！';
        }

        if (value.length > max) {
          return '$nameは$max文字以下で入力してください！';
        }

        return null;
      };
}

/// for between min and max number validator
class BetweenNumberValidator extends Validatable<String?> {
  final String name;
  final int min;
  final int max;

  BetweenNumberValidator({
    required this.name,
    required this.min,
    required this.max,
  }) {
    if (max < min) {
      throw ValidatorException(detail: 'max and min number is invalid');
    }
  }

  @override
  String? Function(String?) get validate => (value) {
        if (value == null || value.isEmpty) {
          return '$nameが空です！';
        }

        int number = 0;

        try {
          number = int.parse(value);
        } catch (e) {
          return '$nameは数値のみで入力してください！';
        }

        if (number < min || number > max) {
          return '$nameは$minから$maxの範囲で入力してください！';
        }

        return null;
      };
}
