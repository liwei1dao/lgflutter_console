import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/splash_view.dart';
import 'components/top_back_skip_view.dart';

class SplashScene extends StatefulWidget {
  const SplashScene({Key? key}) : super(key: key);

  @override
  _SplashSceneState createState() => _SplashSceneState();
}

class _SplashSceneState extends State<SplashScene>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _animationController.animateTo(0.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        child: Stack(
          children: [
            SplashView(
              animationController: _animationController,
            ),
            TopBackSkipView(
              animationController: _animationController,
            ),
          ],
        ),
      ),
    );
  }
}
