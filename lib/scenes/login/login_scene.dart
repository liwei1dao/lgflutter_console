import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'components/login_view.dart';
import 'components/register_view.dart';
import 'components/setting_view.dart';

class LoginScene extends StatefulWidget {
  const LoginScene({Key? key}) : super(key: key);

  @override
  _LoginSceneState createState() => _LoginSceneState();
}

class _LoginSceneState extends State<LoginScene> with TickerProviderStateMixin {
  late AnimationController _loginController;
  late AnimationController _registerController;
  late AnimationController _settingController;
  @override
  void initState() {
    _loginController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _loginController.animateTo(1.0);
    _registerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _registerController.animateTo(0.0);
    _settingController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _settingController.animateTo(0.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7EBE1),
      resizeToAvoidBottomInset: false,
      body: ClipRRect(
        child: Stack(
          children: [
            LoginView(
              animationController: _loginController,
              switchPage: setcurrentIndex,
            ),
            RegisterView(
              animationController: _registerController,
              switchPage: setcurrentIndex,
            ),
            SettingView(
              animationController: _settingController,
              switchPage: setcurrentIndex,
            ),
          ],
        ),
      ),
    );
  }

  void setcurrentIndex(int _cIndex) {
    if (_cIndex == 0) {
      _loginController.animateTo(1.0);
      _registerController.animateTo(0.0);
      _settingController.animateTo(0.0);
    } else if (_cIndex == 1) {
      _loginController.animateTo(0.0);
      _registerController.animateTo(1.0);
      _settingController.animateTo(0.0);
    } else {
      _loginController.animateTo(0.0);
      _registerController.animateTo(0.0);
      _settingController.animateTo(1.0);
    }
  }
}
