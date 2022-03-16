import 'package:flutter/material.dart';
import 'package:tasking/module/flow/presentation/page/flow_page.dart';
import 'package:tasking/module/scene/presentation/page/manual/about_the_flow_page.dart';
import 'package:tasking/module/scene/presentation/page/manual/about_the_scene_page.dart';
import 'package:tasking/module/scene/presentation/page/manual/about_the_task_page.dart';
import 'package:tasking/module/scene/presentation/page/manual/how_to_use_page.dart';
import 'package:tasking/module/scene/presentation/page/scene_list_page.dart';
import 'package:tasking/module/task/presentation/page/task_list_page.dart';

/// route key enum
enum AppRoute {
  scenePage,
  flowPage,
  taskPage,
  manualHowToUsePage,
  manualAboutTheFlowPage,
  manualAboutTheScenePage,
  manualAboutTheTaskPage,
}

/// route string name extenstion
extension AppRouteString on AppRoute {
  String get route => name;
}

/// route generator
class AppRouteGenerator {
  /// routes
  final Map<AppRoute, Widget Function(dynamic)> _routes = {
    AppRoute.scenePage: (_) => SceneListPage(),
    AppRoute.flowPage: (args) => FlowPage(scene: args),
    AppRoute.taskPage: (args) => TaskListPage(scene: args),
    AppRoute.manualHowToUsePage: (_) => const HowToUsePage(),
    AppRoute.manualAboutTheFlowPage: (_) => const AboutTheFlowPage(),
    AppRoute.manualAboutTheScenePage: (_) => const AboutTheScenePage(),
    AppRoute.manualAboutTheTaskPage: (_) => const AboutTheTaskPage(),
  };

  /// route name for initialRoute
  String get homeRouteName => homeRoute.route;

  AppRoute get homeRoute => AppRoute.scenePage;

  /// route generate for onGenerateRoute
  Route<dynamic> generate(RouteSettings settings) {
    final name = settings.name;

    final page = _routes.keys.firstWhere(
      (route) => route.route == name,
      orElse: () => homeRoute,
    );

    return MaterialPageRoute(
      settings: settings,
      builder: (context) => (settings.arguments == null
          ? _routes[page]!(null)
          : (settings.arguments is Map
              ? _routes[page]!(settings.arguments as Map)
              : _routes[page]!(settings.arguments))),
    );
  }
}
