import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lgflutter_console/api/api.dart';
import 'package:lgflutter_console/generated/l10n.dart';
import 'package:lgflutter_console/managers/router_manger.dart';
import 'package:lgflutter_console/managers/storage_manager.dart';
import 'package:lgflutter_console/models/user_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

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
              height: 175,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset(
                "assets/images/splash_01.svg",
                width: 250,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 25,
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
              child: Consumer<UserModel>(
                builder: (context, usermodel, child) {
                  return InkWell(
                    onTap: () {
                      if (StorageManager.instance
                              .getString(UserModel.kUserToken, "null") ==
                          "null") {
                        widget.animationController.animateTo(0.2);
                      } else {
                        Api.getUserinfoReq({})
                            .then(
                              (data) => {
                                showToast(data.message!),
                                usermodel
                                    .setuserData(UserData.fromJson(data.data)),
                                Navigator.of(context)
                                    .pushReplacementNamed(RouteName.home),
                              },
                            )
                            .onError((error, stackTrace) => {
                                  widget.animationController.animateTo(0.2),
                                });
                      }
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
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
