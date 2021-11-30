import 'package:flutter/material.dart';
import 'package:lgflutter_console/models/core.dart';
import 'package:provider/provider.dart';

import 'managers/dio_manager.dart';
import 'managers/router_manger.dart';
import 'managers/storage_manager.dart';
import 'models/app_model.dart';

void main() {
  StorageManager.instance.init();
  DioManager.instance.init(baseUrl: "http://2.56.241.72:8080");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          initialRoute: RouteName.login,
        );
      }),
    );
  }
}
