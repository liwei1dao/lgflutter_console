import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  final AnimationController animationController;
  const SplashView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    final sceneOutAnim =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -1))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.easeOutSine,
      ),
    ));
    return SlideTransition(
      position: sceneOutAnim,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 75,
            )
          ],
        ),
      ),
    );
  }
}
