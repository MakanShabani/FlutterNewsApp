import '../entities/authenticated_user_model.dart';
import '../entities/entities.dart';
import '../entities/ViewModels/view_models.dart';

abstract class AuthenticationRepository {
  Future<ResponseModel<AuthenticatedUserModel>> login(
      {required UserLoginVm loginVm});

  Future<ResponseModel<AuthenticatedUserModel>> registerUser(
      {required UserRegisterVm registerVm});

  Future<ResponseModel<void>> logout();
}
