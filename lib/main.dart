import 'package:flutter/material.dart';

import 'manager/router_manger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Lego",
      onGenerateRoute: RouterManager.generateRoute,
      initialRoute: RouteName.splash,
    );
  }
}
