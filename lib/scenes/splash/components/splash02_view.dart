import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lgflutter_console/generated/l10n.dart';

class Splash02View extends StatefulWidget {
  final AnimationController animationController;
  const Splash02View({Key? key, required this.animationController})
      : super(key: key);

  @override
  _Splash02ViewState createState() => _Splash02ViewState();
}

class _Splash02ViewState extends State<Splash02View> {
  @override
  Widget build(BuildContext context) {
    final sceneInAnim =
        Tween<Offset>(begin: const Offset(0, 2), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.easeOutSine,
      ),
    ));
    final sceneOutAnim =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(1, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        0.2,
        0.4,
        curve: Curves.easeOutSine,
      ),
    ));
    return SlideTransition(
      position: sceneInAnim,
      child: SlideTransition(
        position: sceneOutAnim,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 175,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset(
                  "assets/images/splash_02.svg",
                  width: 250,
                ),
              ),
              const SizedBox(
                height: 75,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                child: Text(
                  S.of(context).legoConsole,
                  style: const TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 64, right: 64),
                child: Text(
                  S.of(context).legoConsoleDes,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
