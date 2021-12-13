import 'package:lgflutter_console/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'app_model.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
];

/// 独立的model
List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<AppModel>(
    create: (context) => AppModel(),
  ),
  ChangeNotifierProvider<UserModel>(
    create: (context) => UserModel(),
  ),
];
