import 'package:flutter/material.dart';

class PorjectData {
  String? projectName;
  String? projectDes;
  num? projectVersion;
  String? projectTime;
  Map<String, dynamic>? projectMember;
  PorjectData.fromJson(Map<String, dynamic> json) {
    projectName = json['ProjectName'];
    projectDes = json['ProjectDes'];
    projectVersion = json['ProjectVersion'];
    projectTime = json['ProjectTime'];
    projectMember = json['ProjectMember'];
  }
}

///用户数据模块
class PorjectModel with ChangeNotifier {
  PorjectData? _projectData;
  PorjectData? get projectData => _projectData;

  setprojectData(PorjectData projectData) {
    _projectData = projectData;
  }
}
