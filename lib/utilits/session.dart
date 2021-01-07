import 'dart:ui';

import 'package:mnasbti_admin/Model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config.dart';

class StorageUtil
{

 static  saveLogin( Map<String, dynamic> data ) async
 {
   var prefs = await SharedPreferences.getInstance();
   await prefs.setString("user_name", data["user_name"]);
   await prefs.setString("phone", data["phone"]);
   await prefs.setString("image", Config.ImagePath+data["image"]);
   await prefs.setString("user_id", data["user_id"]);
   await prefs.setBool("isLogin", true);
 }


 static  Loginout(  ) async
 {
   var prefs = await SharedPreferences.getInstance();
   await prefs.setString("user_name","");
   await prefs.setString("phone",  "");
   await prefs.setString("image" ,"");
   await prefs.setString("user_id", "");
   await prefs.setBool("isLogin", false);
 }


 static Future<dynamic> getLogin() async
 {
   var prefs = await SharedPreferences.getInstance();
   return prefs.getBool("isLogin");
 }


 static Future<dynamic> getLoginInfo() async
 {
   var prefs = await SharedPreferences.getInstance();
   var user_name = prefs.getString("user_name");
   var  phone = prefs.getString("phone");
   var image = prefs.getString("image") ;
   var user_id = prefs.getString("user_id") ;
   var toekn = prefs.getString("token");
   var isLogin = prefs.getBool("isLogin");


   User user ;
   user = new User(user_id, user_name,image, phone, "-","1", isLogin,toekn);

   return user;
 }





 /************ FCM Token *********************/

 static  saveToken( String token ) async
 {
   print("saveToken::"+token);
   var prefs = await SharedPreferences.getInstance();
   await prefs.setString("token", token);
 }

  static void saveUserInfo(info) async
 {
    var prefs = await SharedPreferences.getInstance();
    //print(info);
    await prefs.setString("user_info", info);
  }


}





