import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lgflutter_console/api/api.dart';
import 'package:oktoast/oktoast.dart';

class RegisterView extends StatefulWidget {
  final AnimationController animationController;
  final void Function(int _cindex) switchPage;
  const RegisterView(
      {Key? key, required this.animationController, required this.switchPage})
      : super(key: key);
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _verification = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  late int lefttime = 0;
  late Timer _timer;

  @override
  void initState() {
    lefttime = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final positionOutAnim =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        0.0,
        1.0,
        curve: Curves.easeOutSine,
      ),
    ));
    return SlideTransition(
      position: positionOutAnim,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 125,
            ),
            SizedBox(
              width: 250,
              child: Image.asset(
                'assets/images/login_03.png',
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
                      controller: _email,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "邮件地址",
                        prefixIcon: Icon(Icons.mail),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _verification,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: "验证码",
                              prefixIcon: Icon(Icons.verified),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: lefttime > 0
                                ? null
                                : () {
                                    Api.verificationReq(
                                      {
                                        "PhonOrEmail": _email.text,
                                        "CaptchaType": 0
                                      },
                                    ).then(
                                      (data) => {
                                        if (data.code == 0)
                                          {_startverlefttimer()}
                                      },
                                    );
                                  },
                            child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: lefttime > 0
                                      ? Colors.blue[100]
                                      : Colors.blue,
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                child: Text(
                                  lefttime > 0 ? lefttime.toString() : '获取验证码',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: _password,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "密码",
                        prefixIcon: Icon(Icons.mail),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: _confirmpassword,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "确认密码",
                        prefixIcon: Icon(Icons.mail),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: 36,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xff132137),
                      ),
                      child: InkWell(
                        onTap: () {
                          Api.registerByCaptchaReq(
                            {
                              "PhonOrEmail": _email.text,
                              "Password": _password.text,
                              "Captcha": _verification.text,
                            },
                          ).then(
                            (data) => {showToast(data.message!)},
                          );
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '注册账号',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      child: const Text("to login"),
                      onPressed: () {
                        widget.switchPage(0);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///启动验证码 倒计时
  _startverlefttimer() {
    lefttime = 60;

    ///间隔1秒
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      ///自增
      lefttime--;

      ///到5秒后停止
      if (lefttime <= 0) {
        _timer.cancel();
      }
      setState(() {});
    });
  }
}
