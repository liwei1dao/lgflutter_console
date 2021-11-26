import 'package:flutter/material.dart';

class TopBackSkipView extends StatefulWidget {
  final AnimationController animationController;
  const TopBackSkipView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _TopBackSkipView createState() => _TopBackSkipView();
}

class _TopBackSkipView extends State<TopBackSkipView> {
  @override
  Widget build(BuildContext context) {
    final sceneInAnim =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(0.0, 0.2, curve: Curves.easeOutSine),
    ));
    return SlideTransition(
      position: sceneInAnim,
    );
  }
}
