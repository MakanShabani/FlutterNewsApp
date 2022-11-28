import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../infrastructure/utils/utils.dart';
import '../domain/user.dart';

class AuthenticatedUserService {
  final String userInfoKey = 'user';

  Future<DualData<bool, User>> loadAndCheckUserCredentials() async {
    User? user = await getUserInfo();

    if (user == null || user.expireAt.isBefore(DateTime.now())) {
      await removeUserInfo();
      return DualData(false, null);
    }

    return DualData(true, user);
  }

  Future<bool> saveUserInfo(User user) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    return await prefs.setString(userInfoKey, jsonEncode(user.toJson()));
  }

  Future<bool> removeUserInfo() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    return await prefs.remove(userInfoKey);
  }

  Future<User?> getUserInfo() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    final String? userInfoJsonString = prefs.getString(userInfoKey);

    if (userInfoJsonString == null) return null;

    Map<String, dynamic> userInfoMap = jsonDecode(userInfoJsonString);

    return User.fromJson(userInfoMap);
  }
}
