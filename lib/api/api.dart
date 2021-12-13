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
  ///验证码请求
  static Future<ApiResult> verificationReq(Map<String, dynamic>? params) async {
    final response = await DioManager.instance
        .post("/lego/api/sendemailcaptcha", data: params);
    var data = ApiResult.fromJson(response);
    return data;
  }

  ///注册请求
  static Future<ApiResult> registerByCaptchaReq(
      Map<String, dynamic>? params) async {
    final response = await DioManager.instance
        .post("/lego/user/registerbycaptcha", data: params);
    var data = ApiResult.fromJson(response);
    return data;
  }

  ///登陆请求 验证码
  static Future<ApiResult> loginByCaptchaReq(
      Map<String, dynamic>? params) async {
    final response = await DioManager.instance
        .post("/lego/user/loginbycaptcha", data: params);
    var data = ApiResult.fromJson(response);
    return data;
  }

  ///登陆请求 密码
  static Future<ApiResult> loginByPasswordReq(
      Map<String, dynamic>? params) async {
    final response = await DioManager.instance
        .post("/lego/user/loginbypassword", data: params);
    var data = ApiResult.fromJson(response);
    return data;
  }

  ///获取用户信息
  static Future<ApiResult> getUserinfoReq(Map<String, dynamic>? params) async {
    final response =
        await DioManager.instance.post("/lego/user/getuserinfo", data: params);
    var data = ApiResult.fromJson(response);
    return data;
  }

  ///登出
  static Future<ApiResult> loginOutReq(Map<String, dynamic>? params) async {
    final response =
        await DioManager.instance.post("/lego/user/loginout", data: params);
    var data = ApiResult.fromJson(response);
    return data;
  }
}
