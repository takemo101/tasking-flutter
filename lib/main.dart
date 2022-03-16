import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/scene/presentation/page/scene_list_page.dart';
import 'package:tasking/module/shared/presentation/route.dart';

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
    final routeGenerator = AppRouteGenerator();

    return MaterialApp(
      title: 'Tasking!',
      theme: ThemeData(
        disabledColor: Colors.grey,
        primarySwatch: Colors.green,
      ),
      initialRoute: routeGenerator.homeRouteName,
      onGenerateRoute: routeGenerator.generate,
      home: const SceneListPage(),
    );
  }
}
