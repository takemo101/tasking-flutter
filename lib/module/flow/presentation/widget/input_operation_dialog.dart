import 'package:flutter/material.dart';
import 'package:tasking/module/flow/presentation/widget/color_dropdown.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/presentation/validator/validator.dart';
import 'package:tasking/module/shared/presentation/widget/error_dialog.dart';

typedef SaveCallback = Future<AppResult<SceneID, ApplicationException>>
    Function(String, int);

class NameEditingController = TextEditingController with Type;

class InputOperationDialog extends StatelessWidget {
  final BuildContext _context;
  final String heading;
  final int color;
  final SaveCallback onSave;
  final NameEditingController _nameController;

  final _formKey = GlobalKey<FormState>();

  InputOperationDialog({
    required BuildContext context,
    required this.heading,
    required this.color,
    required this.onSave,
    String name = '',
    Key? key,
  })  : _context = context,
        _nameController = NameEditingController()..text = name,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Color(color);

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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'オペレーションネーム',
                    hintText: 'タスクの進捗に応じた名前',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validators.to([
                    NameValidator(name: 'オペレーションネーム', max: 8),
                  ]),
                ),
                ColorDropdown(
                  color: selectedColor,
                  onChanged: (c) => selectedColor = c,
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
                onPressed: () async => _onPressed(context, selectedColor.value),
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

  Future<void> _onPressed(BuildContext context, int color) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await onSave(
        _nameController.text,
        color,
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
