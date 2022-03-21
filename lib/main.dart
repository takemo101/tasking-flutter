import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/module/scene/presentation/page/scene_list_page.dart';
import 'package:tasking/module/shared/infrastructure/dotenv/initializer.dart';
import 'package:tasking/module/shared/infrastructure/initializer.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/initializer.dart';
import 'package:tasking/module/shared/presentation/route.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initialize();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );

  FlutterNativeSplash.remove();
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
      home: SceneListPage(),
    );
  }
}

Future<void> initialize() async {
  final initializer = Initializer([
    DotEnvInitializer(),
    SQLiteInitializer(),
  ]);

  await initializer.initialize();
}
