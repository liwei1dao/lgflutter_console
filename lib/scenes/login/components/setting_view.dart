import 'package:flutter/material.dart';
import 'package:lgflutter_console/managers/dio_manager.dart';
import 'package:lgflutter_console/models/app_model.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  final AnimationController animationController;
  final void Function(int _cindex) switchPage;
  const SettingView(
      {Key? key, required this.animationController, required this.switchPage})
      : super(key: key);
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
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
                'assets/images/login_02.png',
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
                child: Consumer<AppModel>(builder: (context, appmodel, child) {
                  return Column(
                    children: [
                      TextField(
                        onSubmitted: (v) {
                          appmodel.setserverAddr(v);
                        },
                        autofocus: true,
                        controller: TextEditingController()
                          ..text = appmodel.serverAddr,
                        decoration: const InputDecoration(
                          hintText: "服务端地址",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextField(
                        onSubmitted: (v) {
                          appmodel.setserverSginKey(v);
                        },
                        autofocus: true,
                        controller: TextEditingController()
                          ..text = appmodel.serverSginKey,
                        decoration: const InputDecoration(
                          hintText: "请求密钥",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 56,
                      ),
                      IconButton(
                        iconSize: 45,
                        color: Colors.grey,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          DioManager.instance.init(
                              baseUrl: appmodel.serverAddr,
                              signKey: appmodel.serverSginKey);
                          widget.switchPage(0);
                        },
                      )
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
