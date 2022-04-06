import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/application/dto/alarm_data.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';

class DayOfWeekCheckboxes extends StatefulWidget {
  final List<DayOfWeek> dayOfWeeks;
  final Function(List<DayOfWeek>) onChanged;

  const DayOfWeekCheckboxes({
    required this.dayOfWeeks,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _DayOfWeekCheckboxesState createState() => _DayOfWeekCheckboxesState();
}

class _DayOfWeekCheckboxesState extends State<DayOfWeekCheckboxes> {
  final List<DayOfWeek> _weeks = DayOfWeek.values;
  List<DayOfWeek> _value = [];

  @override
  initState() {
    super.initState();

    _value = widget.dayOfWeeks;
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: '曜日',
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var week in _weeks)
            Expanded(
              child: Column(
                children: [
                  Text(week.jpname),
                  Checkbox(
                    value: _value.contains(week),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      var changeWeeks = _value.toList();

                      if (value) {
                        changeWeeks.add(week);
                      } else {
                        changeWeeks.remove(week);
                      }

                      changeWeeks = changeWeeks.toSet().toList();

                      setState(() => _value = changeWeeks);
                      widget.onChanged(changeWeeks);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
