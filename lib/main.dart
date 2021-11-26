import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'managers/router_manger.dart';
import 'models/app_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  get providers => null;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<AppModel>(builder: (context, appmodel, child) {
        return MaterialApp(
          title: "Lego",
          theme: appmodel.themeData(),
          darkTheme: appmodel.themeData(isdark: true),
          onGenerateRoute: RouterManager.generateRoute,
          initialRoute: RouteName.splash,
        );
      }),
    );
  }
}
