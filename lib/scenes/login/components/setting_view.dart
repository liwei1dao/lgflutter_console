import 'package:flutter/material.dart';
import 'package:lgflutter_console/models/app_model.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key, required this.switchPage}) : super(key: key);
  final void Function(int _cindex) switchPage;
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
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
    );
  }
}
