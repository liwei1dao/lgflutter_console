import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/login_view.dart';

class LoginScene extends StatefulWidget {
  const LoginScene({Key? key}) : super(key: key);

  @override
  _LoginSceneState createState() => _LoginSceneState();
}

class _LoginSceneState extends State<LoginScene> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        child: Stack(
          children: [
            LoginView(),
          ],
        ),
      ),
    );
  }
}
