import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
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
    _dio.interceptors.add(NetCacheInterceptor()); //缓存

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
    // Map<String, dynamic> _authorization = getAuthorizationHeader();
    // if (_authorization != null) {
    //   requestOptions = requestOptions.merge(headers: _authorization);
    // }
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
          try {
            int? errCode = error.response!.statusCode;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
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
                  // return ErrorEntity(code: errCode, message: "未知错误");
                  return AppException(errCode!, error.response!.statusMessage!);
                }
            }
          } on Exception catch (_) {
            return AppException(-1, "未知错误");
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

class MyDioSocketException extends SocketException {
  @override
  late String message;

  MyDioSocketException(
    message, {
    osError,
    address,
    port,
  }) : super(
          message,
          osError: osError,
          address: address,
          port: port,
        );
}

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  // 是否有网
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler errCb) async {
    // 自定义一个socket实例，因为dio原生的实例，message属于是只读的
    if (err.error is SocketException) {
      err.error = MyDioSocketException(
        err.message,
        osError: err.error?.osError,
        address: err.error?.address,
        port: err.error?.port,
      );
    }
    if (err.type == DioErrorType.other) {
      bool isConnectNetWork = await isConnected();
      if (!isConnectNetWork && err.error is MyDioSocketException) {
        err.error.message = "当前网络不可用，请检查您的网络";
      }
    }
    // error统一处理
    AppException appException = AppException.create(err);
    // 错误提示
    debugPrint('DioError===: ${appException.toString()}');
    err.error = appException;
    return super.onError(err, errCb);
  }
}

/// 请求处理拦截器
class RequestInterceptor extends Interceptor {
  // 是否有网
  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

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
    debugPrint(
        '======================\n*** Request *** \nData:\n ${options.data.toString()} \nQuery:\n ${options.queryParameters.toString()} \n======================');
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
    return super.onResponse(response, handle);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  onError(err, handle) async {
    if (err.error is SocketException) {
      err.error = MyDioSocketException(
        err.message,
        osError: err.error?.osError,
        address: err.error?.address,
        port: err.error?.port,
      );
    }
    if (err.type == DioErrorType.other) {
      bool isConnectNetWork = await _isConnected();
      if (!isConnectNetWork && err.error is MyDioSocketException) {
        err.error.message = "当前网络不可用，请检查您的网络";
      }
    }
    AppException appException = AppException.create(err);
    // 错误提示
    debugPrint('DioError===: ${appException.toString()}');
    err.error = appException;
    return super.onError(err, handle);
  }
}

class CacheObject {
  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;
  Response response;
  int timeStamp;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class NetCacheInterceptor extends Interceptor {
  var cache = <String, CacheObject>{};
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
    if (!cacheEnable) handler.next(options);

    // refresh标记是否是刷新缓存
    bool refresh = options.extra["refresh"] == true;

    // 是否磁盘缓存
    bool cacheDisk = options.extra["cacheDisk"] == true;

    // 如果刷新，先删除相关缓存
    if (refresh) {
      // 删除uri相同的内存缓存
      delete(options.uri.toString());

      // 删除磁盘缓存
      if (cacheDisk) {
        await StorageManager.instance.remove(options.uri.toString());
      }

      handler.next(options);
    }

    // get 请求，开启缓存
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == 'get') {
      String key = options.extra["cacheKey"] ?? options.uri.toString();

      // 策略 1 内存缓存优先，2 然后才是磁盘缓存

      // 1 内存缓存
      var ob = cache[key];
      if (ob != null) {
        //若缓存未过期，则返回缓存内容
        if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 <
            cacheMaxage) {
          handler.resolve(cache[key]!.response);
        } else {
          //若已过期则删除缓存，继续向服务器请求
          cache.remove(key);
        }
      }

      // 2 磁盘缓存
      if (cacheDisk) {
        var cacheData = StorageManager.instance.getJSON(key);
        if (cacheData != null) {
          handler.resolve(Response(
            statusCode: 200,
            data: cacheData,
            requestOptions: options,
          ));
        }
      }
    }
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);
    // 如果启用缓存，将返回结果保存到缓存
    if (cacheEnable) {
      await _saveCache(response);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }

  void delete(String key) {
    cache.remove(key);
  }

  Future<void> _saveCache(Response object) async {
    RequestOptions options = object.requestOptions;

    // 只缓存 get 的请求
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == "get") {
      // 策略：内存、磁盘都写缓存

      // 缓存key
      String key = options.extra["cacheKey"] ?? options.uri.toString();

      // 磁盘缓存
      if (options.extra["cacheDisk"] == true) {
        await StorageManager.instance.saveJSON(key, object.data);
      }

      // 内存缓存
      // 如果缓存数量超过最大数量限制，则先移除最早的一条记录
      if (cache.length == cacheMaxcount) {
        cache.remove(cache[cache.keys.first]);
      }
      cache[key] = CacheObject(object);
    }
  }
}
