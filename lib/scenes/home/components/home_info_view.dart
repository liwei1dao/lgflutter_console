import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lgflutter_console/api/api.dart';
import 'package:lgflutter_console/apptheme.dart';
import 'package:lgflutter_console/managers/dio_manager.dart';
import 'package:lgflutter_console/models/project_model.dart';
import 'package:provider/provider.dart';

class HomeInfoView extends StatefulWidget {
  const HomeInfoView({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;
  @override
  _HomeInfoViewState createState() => _HomeInfoViewState();
}

class _HomeInfoViewState extends State<HomeInfoView> {
  Animation<double>? viewanimation;
  @override
  void initState() {
    viewanimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController!,
        curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: Consumer<PorjectModel>(builder: (context, prohectmodel, child) {
        return prohectmodel.projectData != null
            ? infoview(prohectmodel)
            : FutureBuilder<ApiResponse<PorjectData>>(
                future: getPorjectData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    ApiResponse<PorjectData> result = snapshot.data;
                    if (result.status == Status.COMPLETED) {
                      prohectmodel.setprojectData(result.data!);
                      return infoview(prohectmodel);
                    } else {
                      return Center(
                        child: Text(result.toString()),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
      }),
    );
  }

  Future<ApiResponse<PorjectData>> getPorjectData() async {
    ApiResponse<PorjectData> res = await Api.getprojectinfoReq({});
    return res;
  }

  Widget infoview(PorjectModel model) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          color: const Color(0xffF7EBE1),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: SvgPicture.asset(
                  "assets/images/home_hostinfo.svg",
                  height: 300,
                ),
              ),
              Center(
                heightFactor: 8,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 650,
                    maxHeight: 300,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        Container(
                          width: 650,
                          padding: const EdgeInsets.only(left: 32),
                          child: const Text(
                            "项目介绍",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 650,
                          padding: const EdgeInsets.only(left: 32),
                          child: Text(
                            "项目 : " + model.projectData!.projectName!,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
      ],
    );
  }
}
