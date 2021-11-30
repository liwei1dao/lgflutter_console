import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class Storage {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  saveInteger(String key, int value) => _sharedPreferences.setInt(key, value);

  saveString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  saveJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    _sharedPreferences.setString(key, jsonString);
  }

  saveBool(String key, bool value) => _sharedPreferences.setBool(key, value);

  saveDouble(String key, double value) =>
      _sharedPreferences.setDouble(key, value);

  saveStringList(String key, List<String> value) =>
      _sharedPreferences.setStringList(key, value);

  int getInteger(String key, [int defaultValue = 0]) {
    var value = _sharedPreferences.getInt(key);
    return value ?? defaultValue;
  }

  String getString(String key, [String defaultValue = '']) {
    var value = _sharedPreferences.getString(key);
    return value ?? defaultValue;
  }

  dynamic getJSON(String key) {
    String? jsonString = _sharedPreferences.getString(key);
    return jsonDecode(jsonString!);
  }

  bool getBool(String key, [bool defaultValue = false]) {
    var value = _sharedPreferences.getBool(key);
    return value ?? defaultValue;
  }

  double getDouble(String key, [double defaultValue = 0.0]) {
    var value = _sharedPreferences.getDouble(key);
    return value ?? defaultValue;
  }

  List<String> getStringList(String key,
      [List<String> defaultValue = const <String>[]]) {
    var value = _sharedPreferences.getStringList(key);
    return value ?? defaultValue;
  }

  Future<bool> remove(String key) {
    return _sharedPreferences.remove(key);
  }

  void clear() {
    _sharedPreferences.clear();
  }
}

class StorageManager extends Storage {
  static StorageManager? _instance;
  static StorageManager get instance => StorageManager();
  StorageManager._internal();
  factory StorageManager() {
    _instance ??= StorageManager._internal();
    return _instance!;
  }
}
