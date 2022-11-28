import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../domain/authentication_models.dart';
import '../dtos/authenticate_dtos.dart';

abstract class AuthenticationRepository {
  Future<ResponseDTO<User>> login({required UserLoginDTO loginVm});

  Future<ResponseDTO<User>> registerUser({required UserRegisterDTO registerVm});

  Future<ResponseDTO<void>> logout({required String userToken});
}
