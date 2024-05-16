import 'package:shared_preferences/shared_preferences.dart';
class Save {
  static SharedPreferences? save;

  static init() async {
    save = await SharedPreferences.getInstance();
  }

  static Future <bool?> setBool(String key, bool value)async{
    return await save?.setBool(key, value);
  }
  static bool? getBool(String key){
    return  save?.getBool(key);
  }
  static Future <bool?> setString(String key, String value)async{
    return await save?.setString(key, value);
  }
  static String? getString(String key){
    return  save?.getString(key);
  }
  static Future <bool?> setInt(String key, int value)async{
    return await save?.setInt(key, value);
  }
  static int? getInt(String key){
    return  save?.getInt(key);
  }
  static Future <bool?> setDouble(String key, double value)async{
    return await save?.setDouble(key, value);
  }
  static double ? getDouble(String key){
    return  save?.getDouble(key);
  }
  static removeData(String key){
    return save?.remove(key);
  }

}