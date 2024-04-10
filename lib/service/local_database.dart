import 'dart:convert';
import 'package:chat_app/modal/userInfo_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceStorage{
  static Future<bool> saveUserInfo(UserInfoModal userInfoModal) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("user_info", jsonEncode(userInfoModal.toJson()));
  }
  
  static Future<UserInfoModal> getUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString("user_info");
    return UserInfoModal.fromJson(jsonDecode(value ?? ''));
  }

  static Future<bool> checkIfLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.containsKey("user_info");
    if(isLogin == true){
    }
    return isLogin;
  }
  static Future<void> clearUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}