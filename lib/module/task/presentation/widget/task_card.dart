import 'package:flutter/material.dart';
import 'package:tasking/module/shared/presentation/widget/color_point.dart';
import 'package:tasking/module/task/application/dto/task_data.dart';

class TaskCard extends StatelessWidget {
  final TaskData task;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  const TaskCard({
    required this.task,
    this.trailing,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // operation button widget
    final buttonContent = Material(
      color: Colors.grey[100],
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPoint(
              Color(task.operation.color),
              margin: const EdgeInsets.only(right: 5),
            ),
            Text(
              task.operation.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: onTap != null
                        ? InkWell(
                            child: buttonContent,
                            onTap: onTap,
                          )
                        : buttonContent,
                  ),
                  Text(task.content),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
