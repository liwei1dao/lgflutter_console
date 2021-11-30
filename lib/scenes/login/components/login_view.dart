import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginView extends StatefulWidget {
  final AnimationController animationController;
  const LoginView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _serverAddr = TextEditingController();
    TextEditingController _key = TextEditingController();
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
              height: 275,
            ),
            SizedBox(
              width: 100,
              child: Image.asset(
                'assets/images/lego.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 450,
              child: Padding(
                padding: const EdgeInsets.only(left: 56, right: 56),
                child: Column(
                  children: [
                    TextField(
                      controller: _serverAddr,
                      autofocus: true,
                      decoration: const InputDecoration(
                          hintText: "服务端地址",
                          prefixIcon: Icon(Icons.add_reaction)),
                    ),
                    TextField(
                      controller: _key,
                      autofocus: true,
                      decoration: const InputDecoration(
                          hintText: "密钥", prefixIcon: Icon(Icons.add_reaction)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
