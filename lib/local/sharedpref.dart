
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences preferences;

  Future<void> setPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }
}


class LocalPref {
  static Future<bool> clear() {
    return SharedPrefs.preferences.clear();
  }

  static bool containsKey(String key) {
    return SharedPrefs.preferences.containsKey(key);
  }

  static dynamic get(String key) {
    return SharedPrefs.preferences.get(key);
  }

  static bool? getBool(String key) {
    return SharedPrefs.preferences.getBool(key);
  }

  static double? getDouble(String key) {
    return SharedPrefs.preferences.getDouble(key);
  }

  static int? getInt(String key) {
    return SharedPrefs.preferences.getInt(key);
  }

  static Set<String> getKeys() {
    return SharedPrefs.preferences.getKeys();
  }

  static String? getString(String key) {
    return SharedPrefs.preferences.getString(key);
  }

  static List<String>? getStringList(String key) {
    return SharedPrefs.preferences.getStringList(key);
  }

  static Future<void> reload() {
    return SharedPrefs.preferences.reload();
  }

  static Future<bool> remove(String key) {
    return SharedPrefs.preferences.remove(key);
  }

  static Future<bool> setBool(String key, bool value) {
    return SharedPrefs.preferences.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) {
    return SharedPrefs.preferences.setDouble(key, value);
  }

  static Future<bool> setInt(String key, int value) {
    return SharedPrefs.preferences.setInt(key, value);
  }

  static Future<bool> setString(String key, String value) {
    return SharedPrefs.preferences.setString(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return SharedPrefs.preferences.setStringList(key, value);
  }

  ///Singleton factory
  static final LocalPref _instance = LocalPref._internal();

  factory LocalPref() {
    return _instance;
  }

  LocalPref._internal();
}