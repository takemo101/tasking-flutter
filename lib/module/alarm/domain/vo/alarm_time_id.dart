import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';
import 'package:tasking/module/shared/domain/vo/identity.dart';

@immutable
class AlarmTimeID extends Identity<AlarmTimeID> {
  AlarmTimeID(String value) : super(value);
  AlarmTimeID.generate() : super.generate();

  int toNumberID(DayOfWeek week) {
    final intList = ascii.encode(value);
    return intList.fold(week.index, (int a, int b) => a + b);
  }
}
