import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lgflutter_console/api/api.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key, required this.switchPage}) : super(key: key);
  final void Function(int _cindex) switchPage;
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _verification = TextEditingController();
  late int lefttime = 0;
  late Timer _timer;

  @override
  void initState() {
    lefttime = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                                    if (data.code == 0) {_startverlefttimer()}
                                  },
                                );
                              },
                        child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color:
                                  lefttime > 0 ? Colors.blue[100] : Colors.blue,
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
    ));
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
