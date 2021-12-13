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
  late int _currentIndex = 2;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> appPagelist = [
      LoginView(
        switchPage: setcurrentIndex,
      ),
      RegisterView(
        switchPage: setcurrentIndex,
      ),
      SettingView(
        switchPage: setcurrentIndex,
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xffF7EBE1),
      body: ClipRRect(
        child: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              fillColor: Colors.transparent,
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
            );
          },
          child: appPagelist[_currentIndex],
        ),
      ),
    );
  }

  void setcurrentIndex(int _cIndex) {
    setState(() {
      _currentIndex = _cIndex;
    });
  }
}
