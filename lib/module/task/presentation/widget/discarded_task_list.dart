import 'package:flutter/material.dart';
import 'package:tasking/module/shared/presentation/widget/empty_container.dart';
import 'package:tasking/module/shared/presentation/widget/list_icon_button.dart';
import 'package:tasking/module/task/presentation/notifier/task_notifier.dart';
import 'package:tasking/module/task/presentation/widget/remove_task_button.dart';
import 'package:tasking/module/task/presentation/widget/task_card.dart';

class DiscardedTaskList extends StatelessWidget {
  final TaskNotifier notifier;

  const DiscardedTaskList({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = notifier.discardedList;

    return Container(
      child: list.isNotEmpty
          ? ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final task = list[index];
                return TaskCard(
                  task: task,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListIconButton(
                        icon: Icons.undo,
                        onPressed: () async {
                          await notifier.resume(task.id);
                        },
                      ),
                      RemoveTaskButton(notifier: notifier, id: task.id)
                    ],
                  ),
                );
              },
            )
          : const EmptyContainer('破棄したタスクはありません'),
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
  }
}
