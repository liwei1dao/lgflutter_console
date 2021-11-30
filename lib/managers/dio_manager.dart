// ignore_for_file: constant_identifier_names, avoid_print
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lgflutter_console/managers/storage_manager.dart';

// 是否启用代理
const PROXY_ENABLE = false;

/// 代理服务IP
const PROXY_IP = '192.168.2.237';

/// 代理服务端口
const PROXY_PORT = 8888;
// 是否启用缓存
const CACHE_ENABLE = true;
// 缓存的最长时间，单位（秒）
const CACHE_MAXAGE = 1000;
// 最大缓存数
const CACHE_MAXCOUNT = 100;

class DioManager {
  static DioManager? _instance;
  static DioManager get instance => DioManager();
  factory DioManager() {
    _instance ??= DioManager._internal();
    return _instance!;
  }
  late Dio _dio;

  /// 连接超时时间
  static const int CONNECT_TIMEOUT = 60 * 1000;

  /// 响应超时时间
  static const int RECEIVE_TIMEOUT = 60 * 1000;

  DioManager._internal() {
    /// 初始化基本选项
    BaseOptions options = BaseOptions(
      baseUrl: "http://localhost:8080",
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      validateStatus: (int? status) {
        return status != null && status > 0;
      },
      headers: {},
    );

    /// 初始化dio
    _dio = Dio(options);
    _dio.interceptors.add(RequestInterceptor()); //自定义拦截
    _dio.interceptors.add(ConnectsInterceptor()); //拦截网络
    _dio.interceptors.add(LogInterceptor()); //打开日志
    _dio.interceptors.add(NetCacheInterceptor()); //缓存

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (PROXY_ENABLE) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          return "PROXY $PROXY_IP:$PROXY_PORT";
        };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }
  void init(
      //这个在main或者初始化的时候先调用一下
      {String? baseUrl,
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
  }
}

/// 自定义异常
class AppException implements Exception {
  final String? _message;
  final int? _code;
  AppException([
    this._code,
    this._message,
  ]);

  String toString() {
    return "$_message($_code)";
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
            int? errCode = error.response?.statusCode!;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                {
                  return BadRequestException(errCode, "请求语法错误");
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
                  return AppException(
                      errCode, error.response?.statusMessage ?? '');
                }
            }
          } on Exception catch (_) {
            return AppException(-1, "未知错误");
          }
        }
      default:
        {
          return AppException(-1, error.message);
        }
    }
  }
}

/// 请求错误
class BadRequestException extends AppException {
  BadRequestException([int? code, String? message]) : super(code!, message!);
}

/// 未认证异常
class UnauthorisedException extends AppException {
  UnauthorisedException([int code = -1, String message = ''])
      : super(code, message);
}

/// 请求处理拦截器
class RequestInterceptor extends Interceptor {
  onRequest(options, handle) {
    debugPrint(
        '======================\n*** Request *** \nData:\n ${options.data.toString()} \nQuery:\n ${options.queryParameters.toString()} \n======================');
    // // 设置cookie
    // var cookie = SpUtil.getStringList('cookie');登录时保存cookie

    // if (options.path != 'api/auth/login' &&
    //     cookie != null &&
    //     cookie.length > 0) {
    //   options.headers['cookie'] = cookie;//这里就是除了登录的情况其他都加cookie
    // }
    // options.headers['User-Agent'] = 'gzzoc-1';//
    //
    // if (options.data?.runtimeType == FormData) {
    //   options.headers['content-type'] = 'multipart/form-data';//FormData这种情况改content-type
    // }

    // // 加载动画----这个就是请求页面时的那个loading窗 --处理逻辑 我是用options?.data['showLoading']或options?.queryParameters['showLoading'],
    //就是我们在传参的时候多加一个参数，这个因为前人就这样做的，也跟后端约定的，后端见showLoading不做处理。这样不是很好，反正options是有其他字段加的
    // if (options?.data?.runtimeType == FormData) {
    //   Alert.showLoading();
    // } else if ((options?.data != null &&
    //         false == options?.data['showLoading']) ||
    //     (options?.queryParameters != null &&
    //         false == options?.queryParameters['showLoading'])) {
    //   // 不显示加载动画
    // } else {
    //   Alert.showLoading();
    // }
    ///在这做请求时显不显示Loading的处理

    handle.next(options);
    //return super.onRequest(options);
  }

  @override
  onResponse(response, handle) {
    debugPrint(
        '======================\n*** Response *** \n${response.toString()}');
    if (response.data != null &&
        response.data is Map &&
        response.data['code'] == '0') {
      // 这个条件也是根据自己情况加的
      ///    Alert.hide();请求成功后关闭loading窗

      // 登录请求
      if (response.requestOptions.path == 'api/auth/login') {
        // 缓存cookie
        var cookie = response.headers['set-cookie'];
        //   SpUtil.putStringList('cookie', cookie!);缓存cookie
      }
      handle.next(response);
      //     return super.onResponse(response);
    } else if (response.requestOptions.path ==
            'api/auth/login' && // 登录登录成功, 但没有默认就诊人// 缓存cookie以便后续创建默认就诊人（需求）
        response.data != null &&
        response.data is Map &&
        response.data['code'] == '11') {
      // 缓存cookie
      var cookie = response.headers['set-cookie'];
      //    SpUtil.putStringList('cookie', cookie!);

      //     Alert.hide();
      handle.next(response);
    } else {
      handle.reject(DioError(
          requestOptions: response.requestOptions,
          error: response.data != null &&
                  response.data is Map &&
                  response.data['msg'] != null &&
                  response.data['msg'].length > 0
              ? response.data['msg']
              : '未知错误',
          response: response));
    }
  }

  @override
  onError(err, handle) {
    // Alert.hide();关闭弹窗

    // 账户登录异常
    if (err.response != null &&
        err.response?.data != null &&
        err.response?.data is Map &&
        err.response?.data != null &&
        err.response?.data['code'] == '2') {
      // Alert.showAlert(
      //   message: err.message ?? '未知错误',
      //   showCancel: false,
      //   onConfirm: () {
      //     // 清除账号缓存
      //     SpUtil.putString("account_phone", '');
      //     SpUtil.putString("account_password", '');
      //     SpUtil.putObject("account", '');
      //
      //     // 退出到登录页面
      //     //  push(Routes.login, replace: true, clearStack: true);
      //   },
      // );
    } else {
      //    Alert.showAlert(message: err.message ?? '未知错误', showCancel: false);//在页面显示一个错误弹窗
    }
    AppException appException = AppException.create(err);
    err.error = appException;
    return super.onError(err, handle);
  }
}

/// 拦截网络
class ConnectsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    _request();
  }

  //不知道是不是这样写，网络的
  _request() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else {
      print('没有网络');
      //在这里加一个错误弹窗
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
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
    if (!CACHE_ENABLE) handler.next(options);

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
            CACHE_MAXAGE) {
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
    if (CACHE_ENABLE) {
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
      if (cache.length == CACHE_MAXCOUNT) {
        cache.remove(cache[cache.keys.first]);
      }
      cache[key] = CacheObject(object);
    }
  }
}
