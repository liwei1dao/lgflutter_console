import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lgflutter_console/apptheme.dart';

class HomeMonitorserverView extends StatefulWidget {
  const HomeMonitorserverView({Key? key, this.animationController})
      : super(key: key);
  final AnimationController? animationController;
  @override
  _HomeMonitorserverViewState createState() => _HomeMonitorserverViewState();
}

class _HomeMonitorserverViewState extends State<HomeMonitorserverView> {
  Animation<double>? viewanimation;
  @override
  void initState() {
    viewanimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController!,
        curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 450,
              color: const Color(0xffF7EBE1),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        "assets/images/home_001.svg",
                        height: 300,
                      ),
                    ),
                  ),
                  Center(
                    heightFactor: 5,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 650,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 32),
                        child: const Text(
                          "Server Monitor",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
