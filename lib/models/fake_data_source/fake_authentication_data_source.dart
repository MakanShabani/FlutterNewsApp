import 'dart:ffi';

import 'package:collection/collection.dart';

import '../entities/ViewModels/view_models.dart';
import '../entities/entities.dart';
import 'fake_database.dart';

class FakeAuthenticationDataSource {
  FakeDatabase fakeData = FakeDatabase();

  ResponseModel<AuthenticatedUserModel> registerUser(
      {required UserRegisterVm userRegisterVm}) {
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

      return ResponseModel(statusCode: 409, error: error);
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
        status: UserStatus.active);

    fakeData.authenticatedUser = AuthenticatedUserModel(
        token: 'token ${newUser.email}',
        expirationDate: DateTime.now().add(const Duration(minutes: 5)),
        user: newUser);

    return ResponseModel(
      statusCode: 200,
      data: AuthenticatedUserModel(
        token: 'token ${userRegisterVm.email}',
        expirationDate: DateTime.now().add(const Duration(minutes: 5)),
        user: newUser,
      ),
    );
  }

  ResponseModel<AuthenticatedUserModel> loginUser(
      {required UserLoginVm loginVm}) {
    var user = fakeData.users.firstWhereOrNull(
        (u) => u.email == loginVm.email && u.password == loginVm.password);

    //the user not found or user password is incorrect.
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'Please check your credentials ',
        detail: 'Your Email or password is incorrect.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    //everything is ok

    fakeData.authenticatedUser = AuthenticatedUserModel(
        token: 'token ${user.email}',
        expirationDate: DateTime.now().add(const Duration(minutes: 5)),
        user: user);

    return ResponseModel(
      statusCode: 200,
      data: AuthenticatedUserModel(
        token: 'token ${user.email}',
        expirationDate: DateTime.now().add(const Duration(minutes: 5)),
        user: user,
      ),
    );
  }

  ResponseModel<Void> logoutUser({required String userToken}) {
    //the user not found or user password is incorrect.
    if (!fakeData.isUserTokenValid(token: userToken)) {
      ErrorModel error = ErrorModel(
        message: 'Unauthorized',
        detail:
            'You have not permission to do this action.\nPlease login first.',
        statusCode: 401,
      );

      return ResponseModel(statusCode: 401, error: error);
    }

    //everything is ok

    fakeData.authenticatedUser = null;

    return ResponseModel(statusCode: 204);
  }
}
