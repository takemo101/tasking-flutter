import 'package:flutter/material.dart';
import 'package:tasking/module/flow/application/dto/flow_data.dart';
import 'package:tasking/module/flow/presentation/notifier/flow_notifier.dart';
import 'package:tasking/module/flow/presentation/widget/remove_operation_button.dart';
import 'package:tasking/module/flow/presentation/widget/update_operation_button.dart';
import 'package:tasking/module/shared/presentation/widget/color_point.dart';

class OperationReOrderList extends StatefulWidget {
  final FlowNotifier notifier;
  final String id;
  final List<OperationData> list;
  final Function(List<OperationData>) onChanged;

  const OperationReOrderList({
    required this.notifier,
    required this.id,
    required this.list,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _OperationReOrderListState createState() => _OperationReOrderListState();
}

class _OperationReOrderListState extends State<OperationReOrderList> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (beforeIndex, afterIndex) {
        final index = afterIndex - (beforeIndex < afterIndex ? 1 : 0);

        final operation = widget.list.removeAt(beforeIndex);

        setState(() {
          widget.list.insert(index, operation);
          widget.onChanged([...widget.list]);
        });
      },
      children: widget.list.map(
        (OperationData operation) {
          return ListTile(
            key: Key(operation.id),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.drag_indicator,
                  color: Colors.grey,
                ),
                ColorPoint(
                  Color(operation.color),
                  margin: const EdgeInsets.only(left: 5),
                ),
              ],
            ),
            title: Text(operation.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!operation.isDefault)
                  RemoveOperationButton(
                    notifier: widget.notifier,
                    id: widget.id,
                    operationID: operation.id,
                  ),
                UpdateOperationButton(
                  notifier: widget.notifier,
                  operation: operation,
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
