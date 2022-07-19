import 'models/entities/authenticated_user_model.dart';

class UserCredentials {
  static final UserCredentials _instance =
      UserCredentials._privateConstructor();

  factory UserCredentials() {
    return _instance;
  }

  UserCredentials._privateConstructor();

  AuthenticatedUserModel? authenticatedUser;
}
