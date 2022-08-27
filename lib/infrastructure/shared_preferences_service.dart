import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/entities/entities.dart';

class SharedPreferencesService {
  final String userInfoKey = 'user';

  Future<bool> saveUserInfo(AuthenticatedUserModel user) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    return await prefs.setString(userInfoKey, jsonEncode(user.toJson()));
  }

  Future<bool> removeUserInfo() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    return await prefs.remove(userInfoKey);
  }

  Future<AuthenticatedUserModel?> getUserInfo() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    final String? userInfoJsonString = prefs.getString(userInfoKey);

    if (userInfoJsonString == null) return null;

    Map<String, dynamic> userInfoMap = jsonDecode(userInfoJsonString);

    return AuthenticatedUserModel.fromJson(userInfoMap);
  }
}
