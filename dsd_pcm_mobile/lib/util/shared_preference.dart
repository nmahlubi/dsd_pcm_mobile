// ignore_for_file: deprecated_member_use

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../model/intake/auth_token.dart';

class UserPreferences {
  Future<bool> saveUser(AuthToken user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userId", user.userId ?? 0);
    prefs.setString("username", user.username.toString());
    prefs.setString("firstname", user.firstname.toString());
    prefs.setBool("success", user.success ?? false);
    prefs.setString("message", user.message.toString());
    prefs.setString("token", user.token.toString());
    return prefs.commit();
  }

  Future<AuthToken> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userId = prefs.getInt("userId");
    String username = prefs.getString("username").toString();
    String firstname = prefs.getString("firstname").toString();
    bool? success = prefs.getBool("success");
    String message = prefs.getString("message").toString();
    String token = prefs.getString("token").toString();

    return AuthToken(
        userId: userId,
        username: username,
        firstname: firstname,
        success: success,
        message: message,
        token: token);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    prefs.remove("username");
    prefs.remove("firstname");
    prefs.remove("success");
    prefs.remove("message");
    prefs.remove("token");
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    return token;
  }
}
