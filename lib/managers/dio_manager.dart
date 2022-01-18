import 'dart:convert';
import 'dart:io';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lgflutter_console/managers/storage_manager.dart';

String _signKey = "";
// 是否启用代理
const bool proxyEnable = false;

/// 代理服务IP
const String proxyIp = '192.168.2.237';

/// 代理服务端口
const int proxyPort = 8888;
// 是否启用缓存
const bool cacheEnable = true;
// 缓存的最长时间，单位（秒）
const int cacheMaxage = 1000;
// 最大缓存数
const int cacheMaxcount = 100;

class DioManager {
  static DioManager? _instance;
  static DioManager get instance => DioManager();
  factory DioManager() {
    _instance ??= DioManager._internal();
    return _instance!;
  }
  late Dio _dio;
  final CancelToken _cancelToken = CancelToken();

  /// 连接超时时间
  static const int connectTimeout = 60 * 1000;

  /// 响应超时时间
  static const int receiveTimeout = 60 * 1000;

  DioManager._internal() {
    /// 初始化基本选项
    BaseOptions options = BaseOptions(
      baseUrl: "http://localhost:8080",
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      validateStatus: (int? status) {
        return status != null && status > 0;
      },
      headers: {},
    );

    /// 初始化dio
    _dio = Dio(options);
    _dio.interceptors.add(RequestInterceptor()); //自定义拦截
    _dio.interceptors.add(LogInterceptor()); //打开日志

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (proxyEnable) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          return "PROXY $proxyIp:$proxyPort";
        };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }
  void init(
      //这个在main或者初始化的时候先调用一下
      {required String baseUrl,
      required String signKey,
      int? connectTimeout,
      int? receiveTimeout,
      List<Interceptor>? interceptors}) {
    _dio.options = _dio.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
    if (interceptors != null && interceptors.isNotEmpty) {
      _dio.interceptors.addAll(interceptors);
    }
    _signKey = signKey;
  }

  /// 设置headers
  void setHeaders(Map<String, dynamic> map) {
    _dio.options.headers.addAll(map);
  }

/*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }

  /// restful get 操作
  Future get(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    bool refresh = false,
    bool noCache = true,
    String? cacheKey,
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "refresh": refresh,
      "noCache": noCache,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    Response response;
    response = await _dio.get(path,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful post 操作
  Future post(
    String path, {
    Map<String, dynamic>? params,
    data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    var response = await _dio.post(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful put 操作
  Future put(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();

    var response = await _dio.put(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful patch 操作
  Future patch(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    var response = await _dio.patch(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful delete 操作
  Future delete(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    var response = await _dio.delete(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful post form 表单提交操作
  Future postForm(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    var data = FormData.fromMap(params!);
    var response = await _dio.post(path,
        data: data,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }
}

enum Status { COMPLETED, ERROR }

class ApiResponse<T> {
  Status status;
  int? code;
  String? message;
  T? data;
  AppException? exception;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.exception) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $exception \n Data : $data";
  }
}

/// 自定义异常
class AppException implements Exception {
  final String _message;
  final int _code;

  AppException(
    this._code,
    this._message,
  );

  @override
  String toString() {
    return "$_code$_message";
  }

  String getMessage() {
    return _message;
  }

  factory AppException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        {
          return BadRequestException(-1, "请求取消");
        }
      case DioErrorType.connectTimeout:
        {
          return BadRequestException(-1, "连接超时");
        }
      case DioErrorType.sendTimeout:
        {
          return BadRequestException(-1, "请求超时");
        }
      case DioErrorType.receiveTimeout:
        {
          return BadRequestException(-1, "响应超时");
        }
      case DioErrorType.response:
        {
          int? errCode = error.response?.statusCode;
          switch (errCode) {
            case 400:
              {
                return BadRequestException(errCode!, "请求语法错误");
              }
            case 401:
              {
                return UnauthorisedException(errCode!, "没有权限");
              }
            case 403:
              {
                return UnauthorisedException(errCode!, "服务器拒绝执行");
              }
            case 404:
              {
                return UnauthorisedException(errCode!, "无法连接服务器");
              }
            case 405:
              {
                return UnauthorisedException(errCode!, "请求方法被禁止");
              }
            case 500:
              {
                return UnauthorisedException(errCode!, "服务器内部错误");
              }
            case 502:
              {
                return UnauthorisedException(errCode!, "无效的请求");
              }
            case 503:
              {
                return UnauthorisedException(errCode!, "服务器挂了");
              }
            case 505:
              {
                return UnauthorisedException(errCode!, "不支持HTTP协议请求");
              }
            default:
              {
                return AppException(-1, error.message);
              }
          }
        }
      default:
        {
          return AppException(-1, error.error.message);
        }
    }
  }
}

/// 请求错误
class BadRequestException extends AppException {
  BadRequestException(int code, String message) : super(code, message);
}

/// 未认证异常
class UnauthorisedException extends AppException {
  UnauthorisedException(int code, String message) : super(code, message);
}

/// 请求处理拦截器
class RequestInterceptor extends Interceptor {
  ///签名
  String _getSign(Map parameter) {
    /// 存储所有key
    List<String> allKeys = [];
    parameter.forEach((key, value) {
      allKeys.add(key + '=' + value.toString() + '&');
    });
    allKeys.sort((obj1, obj2) {
      return obj1.compareTo(obj2);
    });
    String pairsString = allKeys.join("");

    /// 拼接 ABC 是你的秘钥
    String sign = pairsString + 'key=' + _signKey;
    debugPrint("sign:" + sign);
    var content = const Utf8Encoder().convert(sign);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes).toLowerCase();
  }

  @override
  // ignore: avoid_renaming_method_parameters
  onRequest(options, handle) {
    String token = StorageManager.instance.getString('User-Token', "null");
    options.headers['X-Token'] = token;
    options.data['Sign'] = _getSign(options.data);
    handle.next(options);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  onResponse(response, handle) {
    debugPrint(
        '======================\n*** Response *** \n${response.toString()}');
    if (response.data != null &&
        response.data is Map &&
        response.data['code'] == 0) {
      handle.next(response);
    } else {
      handle.reject(DioError(
          requestOptions: response.requestOptions,
          error: BadRequestException(
              response.data['code'], response.data['message']),
          response: response));
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters
  onError(err, handle) async {
    AppException appException = AppException.create(err);
    err.error = appException;
    return super.onError(err, handle);
  }
}
