import 'package:flutter/material.dart';
import 'package:lgflutter_console/managers/storage_manager.dart';

class AppModel with ChangeNotifier {
  /*国家化*/
  static const localeValueList = ['', 'zh-CN', 'en'];
  static const kLocaleIndex = 'kLocaleIndex';
  late int _localeIndex;
  int get localeIndex => _localeIndex;
  Locale? get locale {
    if (_localeIndex > 0) {
      var value = localeValueList[_localeIndex].split("-");
      return Locale(value[0], value.length == 2 ? value[1] : '');
    }
    // 跟随系统
    return null;
  }

  /*主题*/
  static const kThemeIndex = 'kThemeIndex';
  late int _themeindex;
  int get themeIndex => _themeindex;

  /*服务地址*/
  static const kServerAddr = 'kServerAddr';
  late String _serverAddr;
  String get serverAddr => _serverAddr;
  /*服务地址*/
  static const kServerSginKey = 'kServerSginKey';
  late String _serverSginKey;
  String get serverSginKey => _serverSginKey;

  AppModel() {
    _localeIndex = StorageManager.instance.getInteger(kLocaleIndex, 0);
    _themeindex = StorageManager.instance.getInteger(kThemeIndex, 0);
    _serverAddr = StorageManager.instance.getString(kServerAddr, "");
    _serverSginKey = StorageManager.instance.getString(kServerSginKey, "");
  }

  //切换语言
  switchLocale(int index) {
    _localeIndex = index;
    notifyListeners();
    StorageManager.instance.saveInteger(kLocaleIndex, index);
  }

  //切换主题
  switchTheme(int index) {
    _themeindex = index;
    notifyListeners();
    StorageManager.instance.saveInteger(kThemeIndex, index);
  }

  setserverAddr(String addr) {
    _serverAddr = addr;
    notifyListeners();
    StorageManager.instance.saveString(kServerAddr, addr);
  }

  setserverSginKey(String sginkey) {
    _serverSginKey = sginkey;
    notifyListeners();
    StorageManager.instance.saveString(kServerSginKey, sginkey);
  }

  themeData({bool isdark: false}) {
    late Color _primaryColor;
    switch (_themeindex) {
      case 0:
        {
          _primaryColor = Colors.white;
        }
        break;

      case 1:
        {
          _primaryColor = Colors.blue;
        }
        break;

      default:
        {
          _primaryColor = Colors.blue;
        }
        break;
    }
    var themeData = ThemeData(
      primaryColor: _primaryColor,
    );
    return themeData;
  }
}
