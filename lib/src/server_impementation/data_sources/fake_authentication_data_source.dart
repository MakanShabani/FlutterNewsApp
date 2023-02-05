// ignore_for_file: depend_on_referenced_packages
import 'package:collection/collection.dart';

import '../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../infrastructure/shared_models/shared_model.dart';
import '../fake_database.dart';
import '../../features/authentication/domain/authentication_models.dart';
import '../../features/authentication/data/dtos/authenticate_dtos.dart';

class FakeAuthenticationDataSource {
  FakeDatabase fakeData = FakeDatabase();

  ResponseDTO<User> registerUser({required UserRegisterDTO userRegisterVm}) {
    var user =
        fakeData.users.firstWhereOrNull((u) => u.email == userRegisterVm.email);

    //the user already exists.
    if (user != null) {
      ErrorModel error = ErrorModel(
        message: 'This email is already in use',
        detail:
            'There is a user registered with this email.\n if this email belongs to you do login.',
        statusCode: 409,
      );

      return ResponseDTO(statusCode: 409, error: error);
    }

    //everything is ok
    User newUser = User(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        firstName: userRegisterVm.firstName,
        lastName: userRegisterVm.lastName,
        age: userRegisterVm.age,
        email: userRegisterVm.email,
        role: UserRole.client,
        status: UserStatus.active,
        token: 'token ${userRegisterVm.email}',
        expireAt: DateTime.now().add(const Duration(hours: 1)));

    //editServer
    fakeData.signedInUserToken = newUser.token;
    fakeData.signedInUserExpirationDate = newUser.expireAt;
    fakeData.sigendInUserID = newUser.id;

    return ResponseDTO(statusCode: 200, data: newUser);
  }

  ResponseDTO<User> loginUser({required UserLoginDTO loginVm}) {
    var serverUser = fakeData.users.firstWhereOrNull(
        (u) => u.email == loginVm.email && u.password == loginVm.password);

    //the user not found or user password is incorrect.
    if (serverUser == null) {
      ErrorModel error = ErrorModel(
        message: 'Please check your credentials ',
        detail: 'Your Email or password is incorrect.',
        statusCode: 404,
      );

      return ResponseDTO(statusCode: 404, error: error);
    }

    //everything is ok

    User user = User.fromFakeDatabseUser(
        serverUser,
        'token ${serverUser.email}',
        DateTime.now().add(const Duration(hours: 1)));

    //Upate fake database
    fakeData.signedInUserToken = user.token;
    fakeData.signedInUserExpirationDate = user.expireAt;
    fakeData.sigendInUserID = user.id;

    return ResponseDTO(statusCode: 200, data: user);
  }

  ResponseDTO<void> logoutUser({required String userToken}) {
    //the user not found or user password is incorrect.
    if (!fakeData.isUserTokenValid(token: userToken)) {
      ErrorModel error = ErrorModel(
        message: 'Unauthorized',
        detail:
            'You have not permission to do this action.\nPlease login first.',
        statusCode: 401,
      );

      return ResponseDTO(statusCode: 401, error: error);
    }

    //everything is ok

    fakeData.signedInUserToken = null;
    fakeData.signedInUserExpirationDate = null;
    fakeData.sigendInUserID = null;

    return ResponseDTO(statusCode: 204);
  }
}
