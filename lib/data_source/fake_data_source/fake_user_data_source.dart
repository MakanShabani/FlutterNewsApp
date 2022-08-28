// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import 'fake_database.dart';

class FakeUserDataSource {
  FakeDatabase fakeDatabase = FakeDatabase();

  ResponseModel<User> getUser(
      {required String userToken, required String userId}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    User? user = fakeDatabase.users.firstWhereOrNull((u) => u.id == userId);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'User not found',
        detail: 'User not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    //everything is ok

    return ResponseModel<User>(statusCode: 200, data: user);
  }

  ResponseModel<List<User>> getusers(
      {required String userToken, required PagingOptionsVm pagingOptionsVm}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    //everything is ok
    return ResponseModel(
        statusCode: 200,
        data: fakeDatabase.users
            .skip(pagingOptionsVm.offset)
            .take(pagingOptionsVm.limit)
            .toList());
  }

  ResponseModel<User> updateUser(
      {required String userToken, required UserUpdateVm updateVm}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }
    User? user = fakeDatabase.users
        .firstWhereOrNull((u) => u.id == fakeDatabase.authenticatedUser!.id);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'User not found',
        detail: 'User not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    //everything is ok , we perform the update

    if (updateVm.firstName?.isNotEmpty ?? false) {
      user.firstName = updateVm.firstName!;
    }
    if (updateVm.lastName?.isNotEmpty ?? false) {
      user.lastName = updateVm.lastName!;
    }
    if (updateVm.age != null && updateVm.age! > 0) {
      user.age = updateVm.age!;
    }

    if (updateVm.avatarImage != null) {
      //update user avatar on server
    }

    return ResponseModel(statusCode: 200, data: user);
  }
}
