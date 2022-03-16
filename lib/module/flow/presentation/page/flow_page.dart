import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/flow/flow_provider.dart';
import 'package:tasking/module/flow/presentation/widget/add_operation_button.dart';
import 'package:tasking/module/flow/presentation/widget/operation_reorder_list.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';
import 'package:tasking/module/shared/infrastructure/string.dart';
import 'package:tasking/module/shared/presentation/widget/empty_container.dart';

class FlowPage extends ConsumerWidget {
  final SceneData scene;

  const FlowPage({required this.scene, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(flowNotifierProvider(scene.id));
    final detail = notifier.detail;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(StringHelper.limit(scene.name, limit: 8) + 'のフロー'),
      ),
      body: Container(
        child: detail != null
            ? OperationReOrderList(
                notifier: notifier,
                id: detail.id,
                list: detail.operations,
                onChanged: (operations) async {
                  await notifier.reorderOperation(
                    id: scene.id,
                    operationIDs: operations.map<String>((o) => o.id).toList(),
                  );
                },
              )
            : const EmptyContainer('新規オペレーションを追加してください'),
        color: const Color.fromRGBO(255, 255, 255, 1),
      ),
      floatingActionButton: AddOperationButton(notifier: notifier),
    );
  }
}
