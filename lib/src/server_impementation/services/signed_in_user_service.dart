import 'dart:convert';

import '../databse_entities/database_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignedInUserService {
  final String userInfoKey = 'fakeServer_signedInUser';

  Future<DatabaseUser?> loadAndCheckUserCredentials() async {
    DatabaseUser? user = await getUserInfo();

    if (user == null || user.tokenExpiresAt!.isBefore(DateTime.now())) {
      await removeUserInfo();
      return null;
    }

    return user;
  }

  Future<bool> saveUserInfo(DatabaseUser user) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    return await prefs.setString(userInfoKey, jsonEncode(user.toJson()));
  }

  Future<bool> removeUserInfo() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    return await prefs.remove(userInfoKey);
  }

  Future<DatabaseUser?> getUserInfo() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    final String? userInfoJsonString = prefs.getString(userInfoKey);

    if (userInfoJsonString == null) return null;

    Map<String, dynamic> userInfoMap = jsonDecode(userInfoJsonString);

    return DatabaseUser.fromJson(userInfoMap);
  }
}
