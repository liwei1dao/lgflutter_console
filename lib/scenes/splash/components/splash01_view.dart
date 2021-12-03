import 'package:flutter/material.dart';
import 'package:lgflutter_console/generated/l10n.dart';

class Splash01View extends StatefulWidget {
  final AnimationController animationController;
  const Splash01View({Key? key, required this.animationController})
      : super(key: key);

  @override
  _Splash01ViewState createState() => _Splash01ViewState();
}

class _Splash01ViewState extends State<Splash01View> {
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
              child: Image.asset(
                'assets/images/splash_01.png',
                fit: BoxFit.cover,
              ),
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
            const SizedBox(
              height: 48,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16),
              child: InkWell(
                onTap: () {
                  widget.animationController.animateTo(0.2);
                },
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.only(
                    left: 56.0,
                    right: 56.0,
                    top: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38.0),
                    color: const Color(0xff132137),
                  ),
                  child: const Text(
                    "Let's begin",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
