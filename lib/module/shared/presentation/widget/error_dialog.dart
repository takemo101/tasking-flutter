import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final BuildContext _context;
  final String message;
  final VoidCallback? onConfirm;

  const ErrorDialog({
    required BuildContext context,
    required this.message,
    this.onConfirm,
    Key? key,
  })  : _context = context,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error', style: TextStyle(color: Colors.red)),
      content: Text(message),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('OK', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm?.call();
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
