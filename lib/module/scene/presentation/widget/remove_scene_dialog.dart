import 'package:flutter/material.dart';
import 'package:tasking/module/shared/domain/exception.dart';
import 'package:tasking/module/shared/presentation/widget/error_dialog.dart';

typedef RemoveCallback = Future<void> Function();

class RemoveSceneDialog extends StatelessWidget {
  final BuildContext _context;
  final String heading;
  final RemoveCallback onRemove;

  const RemoveSceneDialog({
    Key? key,
    required BuildContext context,
    required this.heading,
    required this.onRemove,
  })  : _context = context,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('シーン削除'),
      content: const Text('このシーンを削除してもよろしいですか？'),
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
                message: e.toString(),
              ).show();
            } catch (_) {
              Navigator.of(context).pop();
              ErrorDialog(
                context: _context,
                message: 'error',
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
