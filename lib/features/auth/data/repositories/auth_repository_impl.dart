import 'package:khazana_app/core/constants/app_constants.dart';
import 'package:khazana_app/features/auth/data/models/user_model.dart';
import 'package:khazana_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;
  final SharedPreferences _sharedPreferences;

  AuthRepositoryImpl(this._supabaseClient, this._sharedPreferences);

  @override
  Future<UserModel> signUp(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception(AppConstants.authErrorMessage);
      }

      final user = response.user!;
      final userModel = UserModel(
        id: user.id,
        email: user.email!,
        createdAt: user.createdAt,
        lastSignInAt: user.lastSignInAt ?? DateTime.now(),
      );

      // Save user session
      await _saveUserSession(userModel);

      return userModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception(AppConstants.authErrorMessage);
      }

      final user = response.user!;
      final userModel = UserModel(
        id: user.id,
        email: user.email!,
        name: user.userMetadata?['name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
        createdAt: user.createdAt,
        lastSignInAt: user.lastSignInAt ?? DateTime.now(),
      );

      // Save user session
      await _saveUserSession(userModel);

      return userModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      await _clearUserSession();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return null;
      }

      return UserModel(
        id: user.id,
        email: user.email!,
        name: user.userMetadata?['name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
        createdAt: user.createdAt,
        lastSignInAt: user.lastSignInAt ?? DateTime.now(),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return _sharedPreferences.getBool(AppConstants.isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveUserSession(UserModel user) async {
    await _sharedPreferences.setString(AppConstants.userIdKey, user.id);
    await _sharedPreferences.setBool(AppConstants.isLoggedInKey, true);
  }

  Future<void> _clearUserSession() async {
    await _sharedPreferences.remove(AppConstants.userIdKey);
    await _sharedPreferences.setBool(AppConstants.isLoggedInKey, false);
  }
}
