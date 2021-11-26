import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteName {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';
}

class RouterManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text(
                      'No route defined for ${settings.name}',
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ));
    }
  }
}

class NoAnimRouteBuilder extends PageRouteBuilder {
  final Widget page;

  NoAnimRouteBuilder(this.page)
      : super(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: const Duration(milliseconds: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child);
}
