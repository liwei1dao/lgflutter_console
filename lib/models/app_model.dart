import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lgflutter_console/managers/storage_manager.dart';

class AppModel with ChangeNotifier {
  /*国家化*/
  static const kLocaleIndex = 'kLocaleIndex';
  late int _localeIndex;
  int get localeIndex => _localeIndex;

  /*主题*/
  static const kThemeIndex = 'kThemeIndex';
  late int _themeindex;
  int get themeIndex => _themeindex;

  AppModel() {
    _localeIndex = StorageManager.instance.getInteger(kLocaleIndex, 0);
    _themeindex = StorageManager.instance.getInteger(kThemeIndex, 0);
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
