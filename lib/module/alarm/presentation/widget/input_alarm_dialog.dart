import 'package:flutter/material.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/presentation/validator/validator.dart';
import 'package:tasking/module/shared/presentation/widget/error_dialog.dart';

typedef SaveCallback = Future<AppResult<AlarmID, ApplicationException>>
    Function(String);

class ContentEditingController = TextEditingController with Type;

class InputAlarmDialog extends StatelessWidget {
  final BuildContext _context;
  final String heading;
  final SaveCallback onSave;
  final ContentEditingController _contentController;

  final _formKey = GlobalKey<FormState>();

  InputAlarmDialog({
    required BuildContext context,
    required this.heading,
    required this.onSave,
    String name = '',
    Key? key,
  })  : _context = context,
        _contentController = ContentEditingController()..text = name,
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
                  controller: _contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'タスク内容',
                    hintText: 'タスクの簡単な内容',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validators.to([
                    NameValidator(name: 'タスク内容', max: 120),
                  ]),
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
                onPressed: () async => _onPressed(context),
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

  Future<void> _onPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await onSave(
        _contentController.text,
      )
        ..onSuccess((_) => Navigator.of(context).pop())
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
