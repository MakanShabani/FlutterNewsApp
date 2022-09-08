import '../models/ViewModels/view_models.dart';
import '../models/entities/entities.dart';

abstract class AuthenticationRepository {
  Future<ResponseModel<AuthenticatedUserModel>> login(
      {required UserLoginVm loginVm});

  Future<ResponseModel<AuthenticatedUserModel>> registerUser(
      {required UserRegisterVm registerVm});

  Future<ResponseModel<void>> logout({required String userToken});
}
