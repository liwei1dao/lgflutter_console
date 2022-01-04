import 'dart:ffi';

import 'package:flutter/material.dart';

class PorjectData {
  String? projectName;
  String? projectDes;
  Float? projectVersion;
  String? projectTime;
  Map<String, String>? projectMember;
  PorjectData.fromJson(Map<String, dynamic> json) {
    projectName = json['ProjectName'];
    projectDes = json['ProjectDes'];
    projectVersion = json['ProjectVersion'];
    projectTime = json['ProjectTime'];
    projectMember = json['ProjectMember'];
  }
}

///用户数据模块
class PorjectModel with ChangeNotifier {}
