import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences?
      sharedPreferences; //Reuse the object without initialization everytime

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> setData(
      {required String key, required dynamic value}) async {
    if (value is int) {
      return await sharedPreferences!.setInt(key, value);
    } else if (value is bool) {
      return await sharedPreferences!.setBool(key, value);
    } else if (value is String) {
      return await sharedPreferences!.setString(key, value);
    } else if (value is double) {
      return await sharedPreferences!.setDouble(key, value);
    }
    return null;
  }

  static dynamic getData(key) {
    return sharedPreferences!.get(key);
  }

  static Future<bool?> removeData(key) {
    return sharedPreferences!.remove(key);
  }
}
