import 'package:flutter/material.dart';
import 'package:lgflutter_console/models/app_model.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  final AnimationController animationController;
  const SettingView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    final sceneOutAnim =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
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
                            prefixIcon: Icon(Icons.add_reaction)),
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
                            prefixIcon: Icon(Icons.add_reaction)),
                      ),
                      const SizedBox(
                        height: 56,
                      ),
                      IconButton(
                        iconSize: 45,
                        color: Colors.grey,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          widget.animationController.animateTo(0.0);
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
