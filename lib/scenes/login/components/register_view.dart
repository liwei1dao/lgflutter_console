import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  final AnimationController animationController;

  const RegisterView({Key? key, required this.animationController})
      : super(key: key);
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    final sceneOutAnim =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -1))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        0.2,
        0.4,
        curve: Curves.easeOutSine,
      ),
    ));
    return SlideTransition(position: sceneOutAnim);
  }
}
