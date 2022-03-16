import 'package:flutter/material.dart';
import 'package:tasking/module/flow/presentation/notifier/flow_notifier.dart';
import 'package:tasking/module/flow/presentation/widget/color_dropdown.dart';
import 'package:tasking/module/flow/presentation/widget/input_operation_dialog.dart';

class AddOperationButton extends StatelessWidget {
  final FlowNotifier notifier;

  const AddOperationButton({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => InputOperationDialog(
        context: context,
        heading: '新規オペレーション',
        color: SelectColors.firstColor().color.value,
        onSave: (name, color) async {
          await notifier.addOpertion(
            name: name,
            color: color,
          );
        },
      ).show(),
    );
  }
}
