import 'dart:io';

import 'package:khazana_app/core/constants/app_constants.dart';
import 'package:khazana_app/core/resources/api_response.dart';
import 'package:khazana_app/core/utils/logger.dart';
import 'package:khazana_app/features/auth/data/models/user_model.dart';
import 'package:khazana_app/features/auth/domain/exceptions/auth_exceptions.dart';
import 'package:khazana_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;
  final SharedPreferences _sharedPreferences;

  AuthRepositoryImpl(this._supabaseClient, this._sharedPreferences);

  @override
  Future<ApiResponse<UserModel>> signUp(String email, String password) async {
    try {
      logger.i('Attempting to sign up with email: $email');
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        logger.e('Sign up failed: User is null');
        throw Exception(AppConstants.authErrorMessage);
      }

      final user = response.user!;
      logger.i('User registered successfully with ID: ${user.id}');
      final userModel = UserModel(
        id: user.id,
        email: user.email!,
        createdAt: user.createdAt,
        lastSignInAt: user.lastSignInAt ?? DateTime.now().toString(),
      );

      // Save user session
      await _saveUserSession(userModel);
      logger.i('User session saved successfully');

      return ApiResponse.success(userModel);
    } on SocketException catch (e) {
      logger.e('Network error during sign up: ${e.message}');
      return ApiResponse.error(AppConstants.networkErrorMessage);
    } on AuthApiException catch (e) {
      logger.e(
        'Supabase AuthApiException during sign up: ${e.message}\nStatus: ${e.statusCode}',
      );
      return ApiResponse.error(e.message);
    } catch (e) {
      // Check if the error is related to network connectivity
      if (e.toString().contains('network') ||
          e.toString().contains('connection') ||
          e.toString().contains('socket') ||
          e.toString().contains('timeout') ||
          e.toString().contains('Failed host lookup')) {
        logger.e('Network error detected during sign up: ${e.toString()}');
        return ApiResponse.error(AppConstants.networkErrorMessage);
      }

      logger.e(
        'Unexpected error during sign up: ${e.toString()}\nStack trace: ${StackTrace.current}',
      );
      return ApiResponse.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<UserModel>> signIn(String email, String password) async {
    try {
      logger.i('Attempting to sign in with email: $email');
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        logger.e('Authentication failed: User is null');
        throw Exception(AppConstants.authErrorMessage);
      }

      final user = response.user!;
      logger.i('User authenticated successfully with ID: ${user.id}');
      final userModel = UserModel(
        id: user.id,
        email: user.email!,
        name: user.userMetadata?['name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
        createdAt: user.createdAt,
        lastSignInAt: user.lastSignInAt ?? DateTime.now().toString(),
      );

      // Save user session
      await _saveUserSession(userModel);
      logger.i('User session saved successfully');

      return ApiResponse.success(userModel);
    } on SocketException catch (e) {
      logger.e('Network error during sign in: ${e.message}');
      return ApiResponse.error(AppConstants.networkErrorMessage);
    } on AuthApiException catch (e) {
      logger.e(
        'Supabase AuthApiException: ${e.message}\nStatus: ${e.statusCode}',
      );
      return ApiResponse.error(e.message);
    } catch (e) {
      // Check if the error is related to network connectivity
      if (e.toString().contains('network') ||
          e.toString().contains('connection') ||
          e.toString().contains('socket') ||
          e.toString().contains('timeout') ||
          e.toString().contains('Failed host lookup')) {
        logger.e('Network error detected during sign in: ${e.toString()}');
        return ApiResponse.error(AppConstants.networkErrorMessage);
      }

      logger.e(
        'Unexpected error during sign in: ${e.toString()}\nStack trace: ${StackTrace.current}',
      );
      return ApiResponse.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse> signOut() async {
    try {
      logger.i('Attempting to sign out user');
      await _supabaseClient.auth.signOut();
      await _clearUserSession();
      logger.i('User signed out successfully');
      return ApiResponse.success(null);
    } on SocketException catch (e) {
      logger.e('Network error during sign out: ${e.message}');
      // For sign out, we can still clear local session even if there's network error
      await _clearUserSession();
      return ApiResponse.error(AppConstants.networkErrorMessage);
    } on AuthApiException catch (e) {
      logger.e(
        'Supabase AuthApiException during sign out: ${e.message}\nStatus: ${e.statusCode}',
      );
      return ApiResponse.error(e.message);
    } catch (e) {
      // Check if the error is related to network connectivity
      if (e.toString().contains('network') ||
          e.toString().contains('connection') ||
          e.toString().contains('socket') ||
          e.toString().contains('timeout') ||
          e.toString().contains('Failed host lookup')) {
        logger.e('Network error detected during sign out: ${e.toString()}');
        // For sign out, we can still clear local session even if there's network error
        await _clearUserSession();
        return ApiResponse.error(AppConstants.networkErrorMessage);
      }

      logger.e(
        'Unexpected error during sign out: ${e.toString()}\nStack trace: ${StackTrace.current}',
      );
      return ApiResponse.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<UserModel?>> getCurrentUser() async {
    try {
      logger.i('Attempting to get current user');
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        logger.i('No current user found');
        return ApiResponse.success(null);
      }

      logger.i('Current user found with ID: ${user.id}');
      UserModel userModel = UserModel(
        id: user.id,
        email: user.email!,
        name: user.userMetadata?['name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
        createdAt: user.createdAt,
        lastSignInAt: user.lastSignInAt ?? DateTime.now().toString(),
      );
      return ApiResponse.success(userModel);
    } on SocketException catch (e) {
      logger.e('Network error while getting current user: ${e.message}');
      return ApiResponse.error(AppConstants.networkErrorMessage);
    } on AuthApiException catch (e) {
      logger.e(
        'Supabase AuthApiException while getting current user: ${e.message}\nStatus: ${e.statusCode}',
      );
      return ApiResponse.error(e.message);
    } catch (e) {
      // Check if the error is related to network connectivity
      if (e.toString().contains('network') ||
          e.toString().contains('connection') ||
          e.toString().contains('socket') ||
          e.toString().contains('timeout') ||
          e.toString().contains('Failed host lookup')) {
        logger.e(
          'Network error detected while getting current user: ${e.toString()}',
        );
        return ApiResponse.error(AppConstants.networkErrorMessage);
      }

      logger.e(
        'Unexpected error while getting current user: ${e.toString()}\nStack trace: ${StackTrace.current}',
      );
      return ApiResponse.error('An unexpected error occurred: ${e.toString()}');
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
