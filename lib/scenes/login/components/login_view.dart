import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lgflutter_console/api/api.dart';
import 'package:lgflutter_console/managers/dio_manager.dart';
import 'package:lgflutter_console/managers/router_manger.dart';
import 'package:lgflutter_console/models/user_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  final AnimationController animationController;
  final void Function(int _cindex) switchPage;
  const LoginView(
      {Key? key, required this.animationController, required this.switchPage})
      : super(key: key);
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.white : Colors.green,
        ),
      );
    },
  );

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
      child: Stack(
        children: [
          fromview(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomRight,
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
        ],
      ),
    );
  }

  Widget fromview() {
    return SingleChildScrollView(
      child: Consumer<UserModel>(builder: (context, usermodel, child) {
        return Column(
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
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => spinkit,
                              fullscreenDialog: true,
                            ),
                          );
                          ApiResponse<UserData> res =
                              await Api.loginByPasswordReq(
                            {
                              "PhonOrEmail": _email.text,
                              "Password": _password.text,
                            },
                          );
                          Navigator.pop(context);
                          if (res.status == Status.COMPLETED) {
                            usermodel.setuserData(res.data!);
                            Navigator.of(context)
                                .pushReplacementNamed(RouteName.home);
                          } else {
                            //异常提示
                            showToast(res.exception!.getMessage());
                          }
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
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
                    const SizedBox(
                      height: 5,
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
          ],
        );
      }),
    );
  }
}
