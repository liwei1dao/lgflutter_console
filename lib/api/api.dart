import 'package:dio/dio.dart';
import 'package:lgflutter_console/managers/dio_manager.dart';
import 'package:lgflutter_console/models/project_model.dart';
import 'package:lgflutter_console/models/user_model.dart';

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
  static Future<ApiResponse<ApiResult>> verificationReq(
      Map<String, dynamic>? params) async {
    try {
      dynamic response = await DioManager.instance
          .post("/lego/api/sendemailcaptcha", data: params);
      ApiResult data = ApiResult.fromJson(response);
      return ApiResponse.completed(data);
    } on DioError catch (e) {
      return ApiResponse.error(e.error);
    }
  }

  ///注册请求
  static Future<ApiResponse<ApiResult>> registerByCaptchaReq(
      Map<String, dynamic>? params) async {
    try {
      dynamic response = await DioManager.instance
          .post("/lego/user/registerbycaptcha", data: params);
      ApiResult data = ApiResult.fromJson(response);
      return ApiResponse.completed(data);
    } on DioError catch (e) {
      return ApiResponse.error(e.error);
    }
  }

  ///登陆请求 验证码
  static Future<ApiResponse<UserData>> loginByCaptchaReq(
      Map<String, dynamic>? params) async {
    try {
      dynamic response = await DioManager.instance
          .post("/lego/user/loginbycaptcha", data: params);
      ApiResult result = ApiResult.fromJson(response);
      UserData data = UserData.fromJson(result.data);
      return ApiResponse.completed(data);
    } on DioError catch (e) {
      return ApiResponse.error(e.error);
    }
  }

  ///登陆请求 密码
  static Future<ApiResponse<UserData>> loginByPasswordReq(
      Map<String, dynamic>? params) async {
    try {
      dynamic response = await DioManager.instance
          .post("/lego/user/loginbypassword", data: params);
      ApiResult result = ApiResult.fromJson(response);
      UserData data = UserData.fromJson(result.data);
      return ApiResponse.completed(data);
    } on DioError catch (e) {
      return ApiResponse.error(e.error);
    }
  }

  ///获取用户信息
  static Future<ApiResponse<UserData>> getUserinfoReq(
      Map<String, dynamic>? params) async {
    try {
      dynamic response = await DioManager.instance
          .post("/lego/user/getuserinfo", data: params);
      ApiResult result = ApiResult.fromJson(response);
      UserData user = UserData.fromJson(result.data);
      return ApiResponse.completed(user);
    } on DioError catch (e) {
      return ApiResponse.error(e.error);
    }
  }

  ///登出
  static Future<ApiResponse<ApiResult>> loginOutReq(
      Map<String, dynamic>? params) async {
    try {
      dynamic response =
          await DioManager.instance.post("/lego/user/loginout", data: params);
      ApiResult data = ApiResult.fromJson(response);
      return ApiResponse.completed(data);
    } on DioError catch (e) {
      return ApiResponse.error(e.error);
    }
  }

  ///获取项目信息
  static Future<ApiResponse<PorjectData>> getprojectinfoReq(
      Map<String, dynamic>? params) async {
    try {
      dynamic response = await DioManager.instance
          .post("/lego/console/getprojectinfo", data: params);
      ApiResult result = ApiResult.fromJson(response);
      PorjectData project = PorjectData.fromJson(result.data);
      return ApiResponse.completed(project);
    } on DioError catch (e) {
      return ApiResponse.error(e.error);
    }
  }

  ///获取主机信息
  static Future<ApiResult> gethostinfoReq(Map<String, dynamic>? params) async {
    final response = await DioManager.instance
        .post("/lego/console/gethostinfo", data: params);
    var data = ApiResult.fromJson(response);
    return data;
  }
}
