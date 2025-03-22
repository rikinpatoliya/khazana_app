import 'package:khazana_app/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signUp(String email, String password);
  Future<UserModel> signIn(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<bool> isLoggedIn();
}
