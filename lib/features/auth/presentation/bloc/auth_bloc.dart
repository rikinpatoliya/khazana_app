import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_app/core/resources/api_response.dart';
import 'package:khazana_app/features/auth/data/models/user_model.dart';
import 'package:khazana_app/features/auth/domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final UserModel user;

  const AuthAuthenticatedState(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitialState()) {
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final apiResponse = await _authRepository.getCurrentUser();
        if (apiResponse is ApiResponseSuccess<UserModel?>) {
          var user = apiResponse.value;
          if (user != null) {
            emit(AuthAuthenticatedState(user));
          } else {
            emit(AuthUnauthenticatedState());
          }
        } else if (apiResponse is ApiResponseError) {
          emit(AuthErrorState(apiResponse.message));
        }
      } else {
        emit(AuthUnauthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final apiResponse = await _authRepository.signUp(
        event.email,
        event.password,
      );
      if (apiResponse is ApiResponseSuccess<UserModel>) {
        emit(AuthAuthenticatedState(apiResponse.value));
      } else if (apiResponse is ApiResponseError) {
        emit(AuthErrorState(apiResponse.message));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final apiResponse = await _authRepository.signIn(
        event.email,
        event.password,
      );
      if (apiResponse is ApiResponseSuccess<UserModel>) {
        emit(AuthAuthenticatedState(apiResponse.value));
      } else if (apiResponse is ApiResponseError) {
        emit(AuthErrorState(apiResponse.message));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      var apiResponse = await _authRepository.signOut();
      if (apiResponse is ApiResponseSuccess) {
        emit(AuthUnauthenticatedState());
      } else if (apiResponse is ApiResponseError) {
        emit(AuthErrorState(apiResponse.message));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
