import 'package:flutter/material.dart';
import 'package:lgflutter_console/models/core.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'managers/dio_manager.dart';
import 'managers/router_manger.dart';
import 'managers/storage_manager.dart';
import 'models/app_model.dart';

Future<void> main() async {
  await StorageManager.instance.init();
  DioManager.instance.init(baseUrl: "http://127.0.0.1:9567");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MultiProvider(
      providers: providers,
      child: Consumer<AppModel>(builder: (context, appmodel, child) {
        return MaterialApp(
          title: "Lego",
          theme: appmodel.themeData(),
          darkTheme: appmodel.themeData(isdark: true),
          locale: appmodel.locale,
          localizationsDelegates: const [
            S.delegate,
          ],
          onGenerateRoute: RouterManager.generateRoute,
          initialRoute: RouteName.home,
        );
      }),
    ));
  }
}
