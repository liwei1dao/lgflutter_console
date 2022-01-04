import 'package:flutter/material.dart';
import 'package:lgflutter_console/managers/storage_manager.dart';

class UserData {
  int? id;
  String? phonOrEmail;
  String? password;
  String? nickName;
  String? headUrl;
  int? userRole;
  String? token;
  UserData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    phonOrEmail = json['PhonOrEmail'];
    password = json['Password'];
    nickName = json['NickName'];
    headUrl = json['HeadUrl'];
    userRole = json['UserRole'];
    token = json['Token'];
  }
}

///用户数据模块
class UserModel with ChangeNotifier {
  //用户Token
  static const kUserToken = 'kUserToken';
  late String _kUserToken;
  String get themeIndex => _kUserToken;

  UserData? _userData;
  UserData? get userData => _userData;

  setuserData(UserData userData) {
    _userData = userData;
    StorageManager.instance.saveString(kUserToken, _userData!.token!);
  }
}
