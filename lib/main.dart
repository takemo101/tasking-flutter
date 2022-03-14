import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/scene/presentation/page/scene_list_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Tasking!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SceneListPage(),
    );
  }
}
