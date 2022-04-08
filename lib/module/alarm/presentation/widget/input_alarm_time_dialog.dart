import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/alarm/presentation/widget/day_of_week_checkboxes.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/domain/vo/day_of_week.dart';
import 'package:tasking/module/shared/presentation/validator/validator.dart';
import 'package:tasking/module/shared/presentation/widget/error_dialog.dart';

typedef SaveCallback = Future<AppResult<AlarmID, ApplicationException>>
    Function(TimeOfDay, List<DayOfWeek>);

class HourEditingController = TextEditingController with Type;
class MinuteEditingController = TextEditingController with Type;

class SelectedAlarmTime {
  List<DayOfWeek> selectedDayOfWeeks;
  SelectedAlarmTime({
    required this.selectedDayOfWeeks,
  });
}

class InputAlarmTimeDialog extends StatelessWidget {
  final BuildContext _context;
  final String heading;
  final SelectedAlarmTime _selected;
  final SaveCallback onSave;
  final HourEditingController _hourController;
  final MinuteEditingController _minuteController;

  final _formKey = GlobalKey<FormState>();

  InputAlarmTimeDialog({
    required BuildContext context,
    required this.heading,
    required TimeOfDay timeOfDay,
    List<DayOfWeek> dayOfWeeks = const <DayOfWeek>[],
    required this.onSave,
    String name = '',
    Key? key,
  })  : _context = context,
        _selected = SelectedAlarmTime(selectedDayOfWeeks: dayOfWeeks),
        _hourController = HourEditingController()
          ..text = timeOfDay.hour.toString(),
        _minuteController = MinuteEditingController()
          ..text = timeOfDay.minute.toString(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: AlertDialog(
            title: Text(heading),
            content: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: _hourController,
                  decoration: const InputDecoration(
                    labelText: '時',
                    hintText: '時数',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validators.to([
                    BetweenNumberValidator(name: '時数', min: 0, max: 23),
                  ]),
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: _minuteController,
                  decoration: const InputDecoration(
                    labelText: '分',
                    hintText: '分数',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validators.to([
                    BetweenNumberValidator(name: '分数', min: 0, max: 59),
                  ]),
                ),
                DayOfWeekCheckboxes(
                  dayOfWeeks: _selected.selectedDayOfWeeks,
                  onChanged: (weeks) => _selected.selectedDayOfWeeks = weeks,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('キャンセル'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('保存'),
                onPressed: () async =>
                    _onPressed(context, _selected.selectedDayOfWeeks),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void show() {
    showDialog<void>(
      context: _context,
      builder: build,
    );
  }

  Future<void> _onPressed(BuildContext context, List<DayOfWeek> weeks) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await onSave(
        TimeOfDay(
          hour: int.parse(_hourController.text),
          minute: int.parse(_minuteController.text),
        ),
        weeks,
      )
        ..onSuccess((_) => Navigator.of(context).pop())
        ..onFailure((e) {
          Navigator.of(context).pop();
          ErrorDialog(
            context: _context,
            message: e.toJP(),
            onConfirm: show,
          ).show();
        })
        ..onError((e) {
          if (e.runtimeType == DomainException) {
            Navigator.of(context).pop();
            ErrorDialog(
              context: _context,
              message: (e as DomainException).toJP(),
              onConfirm: show,
            ).show();
          } else {
            throw e;
          }
        });
    }
  }
}
