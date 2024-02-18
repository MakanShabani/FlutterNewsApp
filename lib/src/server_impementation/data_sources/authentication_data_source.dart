// ignore_for_file: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:shaspeaker_news_app/src/server_impementation/databse_entities/databse_entities.dart';
import 'package:shaspeaker_news_app/src/server_impementation/services/signed_in_user_service.dart';

import '../../features/authentication/data/dtos/authenticate_dtos.dart';
import '../../features/authentication/domain/authentication_models.dart';
import '../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../infrastructure/shared_models/shared_model.dart';
import '../fake_database.dart';

class AuthenticationDataSource {
  FakeDatabase fakeData = FakeDatabase();
  SignedInUserService signedInUserService = SignedInUserService();

  ResponseDTO<User> registerUser({required UserRegisterDTO userRegisterVm}) {
    var user = fakeData.clients
        .firstWhereOrNull((u) => u.email == userRegisterVm.email);

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
    DatabaseUser newUser = DatabaseUser(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        firstName: userRegisterVm.firstName,
        lastName: userRegisterVm.lastName,
        age: userRegisterVm.age,
        email: userRegisterVm.email,
        role: DatabseUserRole.client,
        status: DatabseUserStatus.active,
        token: 'token ${userRegisterVm.email}',
        tokenExpiresAt: DateTime.now().add(const Duration(hours: 1)));

    //editServer
    fakeData.sigendInUser = newUser;
    //save user credentials to database
    signedInUserService.saveUserInfo(newUser);

    return ResponseDTO(
        statusCode: 200, data: User.fromFakeDatabseUser(newUser));
  }

  ResponseDTO<User> loginUser({required UserLoginDTO loginVm}) {
    var serverUser = fakeData.clients.firstWhereOrNull(
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
    //assign token to the loggedIn user
    serverUser.token = 'token ${serverUser.email}';
    serverUser.tokenExpiresAt = DateTime.now().add(const Duration(hours: 1));
    //Upate fake database
    fakeData.sigendInUser = serverUser;
    //save user credentials to database
    signedInUserService.saveUserInfo(serverUser);

    return ResponseDTO(
        statusCode: 200, data: User.fromFakeDatabseUser(serverUser));
  }

  ResponseDTO<void> logoutUser({required String userToken}) {
    //the user not found or user token is incorrect.
    if (!fakeData.isUserTokenValid(token: userToken)) {
      ErrorModel error = ErrorModel(
        message: 'Unauthorized',
        detail:
            'You have not permission to do this action.\nPlease login first.',
        statusCode: 401,
      );

      return ResponseDTO(statusCode: 401, error: error);
    }

    //remove user credentials from database
    signedInUserService.removeUserInfo();
    //everything is ok
    fakeData.sigendInUser = null;

    return ResponseDTO(statusCode: 204);
  }
}
