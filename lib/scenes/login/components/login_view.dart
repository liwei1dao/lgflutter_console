import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key, required this.switchPage}) : super(key: key);
  final void Function(int _cindex) switchPage;
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
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
              'assets/images/login_01.png',
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
                  TextField(
                    controller: _password,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText: "密码", prefixIcon: Icon(Icons.password)),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Container(
                    height: 36,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: const Color(0xff132137),
                    ),
                    child: InkWell(
                      onTap: _login,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Sign Up',
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
                  TextButton(
                    child: const Text("to register"),
                    onPressed: () {
                      widget.switchPage(1);
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 125,
          ),
          Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: IconButton(
              iconSize: 45,
              color: Colors.grey,
              icon: const Icon(Icons.settings),
              onPressed: () {
                widget.switchPage(2);
              },
            ),
          ),
        ],
      ),
    );
  }

  //登陆
  _login() {}
}
