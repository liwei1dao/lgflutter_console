import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key, required this.switchPage}) : super(key: key);
  final void Function(int _cindex) switchPage;
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _verification = TextEditingController();
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
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _verification,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: "验证码",
                          prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        child: const Text(
                          "获取验证码",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
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
}
