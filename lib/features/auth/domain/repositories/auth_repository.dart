import 'package:khazana_app/core/resources/api_response.dart';
import 'package:khazana_app/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<ApiResponse<UserModel>> signUp(String email, String password);
  Future<ApiResponse<UserModel>> signIn(String email, String password);
  Future<ApiResponse> signOut();
  Future<ApiResponse<UserModel?>> getCurrentUser();
  Future<bool> isLoggedIn();
}
