import 'package:flutter/material.dart';
import 'package:tasking/module/flow/presentation/notifier/flow_notifier.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';
import 'package:tasking/module/shared/presentation/widget/remove_dialog.dart';

class RemoveOperationButton extends StatelessWidget {
  final FlowNotifier notifier;
  final String id;
  final String operationID;

  const RemoveOperationButton({
    required this.notifier,
    required this.id,
    required this.operationID,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListIconButton(
      icon: Icons.delete,
      onPressed: () => RemoveDialog(
        context: context,
        title: 'オペレーション削除',
        message: 'このオペレーションを削除してもよろしいですか？',
        onRemove: () async {
          await notifier.removeOperation(
            id: id,
            operationID: operationID,
          );
        },
      ).show(),
    );
  }
}
