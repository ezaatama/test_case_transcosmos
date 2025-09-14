import 'package:flutter/material.dart';
import 'package:test_case_transcosmos/view/homescreen.dart';

class AppRoute {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Homescreen());
      default:
        return _routeError();
    }
  }

  static Route _routeError() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text("Something went wrong!")),
      ),
    );
  }
}
