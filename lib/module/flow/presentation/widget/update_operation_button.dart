import 'package:flutter/material.dart';
import 'package:tasking/module/flow/application/dto/flow_data.dart';
import 'package:tasking/module/flow/presentation/notifier/flow_notifier.dart';
import 'package:tasking/module/flow/presentation/widget/input_operation_dialog.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';

class UpdateOperationButton extends StatelessWidget {
  final FlowNotifier notifier;
  final OperationData operation;

  const UpdateOperationButton({
    required this.notifier,
    required this.operation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListIconButton(
      icon: Icons.edit,
      onPressed: () => InputOperationDialog(
        context: context,
        heading: 'オペレーション編集',
        color: operation.color,
        name: operation.name,
        onSave: (name, color) async {
          await notifier.changeOperation(
            operationID: operation.id,
            name: name,
            color: color,
          );
        },
      ).show(),
    );
  }
}
