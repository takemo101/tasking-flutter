import 'package:flutter/material.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/presentation/widget/error_dialog.dart';

typedef RemoveCallback = Future<void> Function();

class RemoveDialog extends StatelessWidget {
  final BuildContext _context;
  final String title;
  final String message;
  final RemoveCallback onRemove;

  const RemoveDialog({
    required BuildContext context,
    required this.title,
    required this.message,
    required this.onRemove,
    Key? key,
  })  : _context = context,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('削除'),
          onPressed: () async {
            try {
              await onRemove();
              Navigator.of(context).pop();
            } on DomainException catch (e) {
              Navigator.of(context).pop();
              ErrorDialog(
                context: _context,
                message: e.toJP(),
              ).show();
            } on ApplicationException catch (e) {
              Navigator.of(context).pop();
              ErrorDialog(
                context: _context,
                message: e.toJP(),
              ).show();
            }
          },
        ),
      ],
    );
  }

  void show() {
    showDialog<void>(
      context: _context,
      builder: build,
    );
  }
}
