import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:lgflutter_console/managers/dio_manager.dart';

class ApiResult {
  int? code;
  String? message;
  dynamic data;
  ApiResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }
}

class Api {
  ///请求验证码
  static Future<ApiResult> verificationReq(Map<String, dynamic>? params) async {
    final response =
        await DioManager.instance.post("/api/sendemailcaptcha", data: params);
    var data = ApiResult.fromJson(response);
    return data;
  }
}
