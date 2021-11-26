import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _serverAddr = TextEditingController();
    TextEditingController _key = TextEditingController();
    return SingleChildScrollView(
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
          SizedBox(
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
                    decoration: InputDecoration(
                        hintText: "服务端地址",
                        prefixIcon: Icon(Icons.add_reaction)),
                  ),
                  TextField(
                    controller: _key,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: "密钥", prefixIcon: Icon(Icons.add_reaction)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
