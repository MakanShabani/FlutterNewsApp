import '../models/entities/authenticated_user_model.dart';

class LoggedInUserInfo {
  static final LoggedInUserInfo _instance =
      LoggedInUserInfo._privateConstructor();

  factory LoggedInUserInfo() {
    return _instance;
  }

  LoggedInUserInfo._privateConstructor();

  AuthenticatedUserModel? authenticatedUser;
}
