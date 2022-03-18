import 'package:flutter/material.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/scene/presentation/widget/genre_dropdown.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/presentation/validator/validator.dart';
import 'package:tasking/module/shared/presentation/widget/error_dialog.dart';

typedef SaveCallback = Future<AppResult<SceneID, ApplicationException>>
    Function(String, String);

class NameEditingController = TextEditingController with Type;

class InputSceneDialog extends StatelessWidget {
  final BuildContext _context;
  final String heading;
  final GenreData genre;
  final SaveCallback onSave;
  final NameEditingController _nameController;

  final _formKey = GlobalKey<FormState>();

  InputSceneDialog({
    required BuildContext context,
    required this.heading,
    required this.genre,
    required this.onSave,
    String name = '',
    Key? key,
  })  : _context = context,
        _nameController = NameEditingController()..text = name,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    GenreData selectedGenre = genre;

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
                    labelText: 'シーンネーム',
                    hintText: '利用シーンに応じた名前',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validators.to([
                    NameValidator(name: 'シーンネーム', max: 20),
                  ]),
                ),
                GenreDropdown(
                  value: genre,
                  onChanged: (gen) => selectedGenre = gen,
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
                onPressed: () async => _onPressed(context, selectedGenre),
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

  Future<void> _onPressed(BuildContext context, GenreData selectedGenre) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await onSave(
        _nameController.text,
        selectedGenre.label,
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
