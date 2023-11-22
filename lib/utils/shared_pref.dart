import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _pref;

  static Future init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static const String xEnv = "x-env";
  static const String xSearchHistory = "x-search-history";

  //---------------------------------------------------
  static Future<bool> setString(String key, String? val) async {
    if (val != null && val.isNotEmpty) {
      return await _pref?.setString(key, val) ?? false;
    } else {
      return await _pref?.remove(key) ?? false;
    }
  }

  static String getString(String key) {
    try {
      return _pref?.getString(key) ?? "";
    } catch (_) {
      return "";
    }
  }

  static Future<bool> setList(String key, List<String>? val) async {
    if (val != null && val.isNotEmpty) {
      return await _pref?.setStringList(
            key,
            val,
          ) ??
          false;
    } else {
      return await _pref?.remove(key) ?? false;
    }
  }

  static List<String> getList(String key) {
    try {
      return (_pref?.getStringList(key) ?? []);
    } catch (_) {
      return [];
    }
  }

  static clear() {
    setList(xSearchHistory, []);
  }
}
