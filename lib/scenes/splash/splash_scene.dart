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
      backgroundColor: const Color(0xffF7EBE1),
      body: ClipRRect(
        child: Stack(
          children: [
            SplashView(
              animationController: _animationController,
            ),
            TopBackSkipView(
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
              animationController: _animationController,
            ),
          ],
        ),
      ),
    );
  }

  void _onSkipClick() {
    _animationController.animateTo(0.8,
        duration: const Duration(milliseconds: 1200));
  }

  void _onBackClick() {
    if (_animationController.value >= 0 && _animationController.value <= 0.2) {
      _animationController.animateTo(0.0);
    } else if (_animationController.value > 0.2 &&
        _animationController.value <= 0.4) {
      _animationController.animateTo(0.2);
    } else if (_animationController.value > 0.4 &&
        _animationController.value <= 0.6) {
      _animationController.animateTo(0.4);
    } else if (_animationController.value > 0.6 &&
        _animationController.value <= 0.8) {
      _animationController.animateTo(0.6);
    } else if (_animationController.value > 0.8 &&
        _animationController.value <= 1.0) {
      _animationController.animateTo(0.8);
    }
  }
}
