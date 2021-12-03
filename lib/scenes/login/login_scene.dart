import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lgflutter_console/models/app_model.dart';
import 'package:provider/provider.dart';

import 'components/login_view.dart';
import 'components/setting_view.dart';

class LoginScene extends StatefulWidget {
  const LoginScene({Key? key}) : super(key: key);

  @override
  _LoginSceneState createState() => _LoginSceneState();
}

class _LoginSceneState extends State<LoginScene> with TickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    if (context.read<AppModel>().serverAddr == "") {
      _animationController.animateTo(0.2);
    } else {
      _animationController.animateTo(0.0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ClipRRect(
        child: Stack(
          children: [
            LoginView(
              animationController: _animationController,
            ),
            SettingView(
              animationController: _animationController,
            ),
          ],
        ),
      ),
    );
  }
}
