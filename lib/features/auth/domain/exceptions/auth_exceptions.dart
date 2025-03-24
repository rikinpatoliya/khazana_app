class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AuthException {
  NetworkException()
    : super('Network connection error. Please check your internet connection.');
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException() : super('Invalid email or password.');
}

class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('User not found.');
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException() : super('Email is already in use.');
}

class WeakPasswordException extends AuthException {
  WeakPasswordException() : super('Password is too weak.');
}

class ServerException extends AuthException {
  ServerException() : super('Server error. Please try again later.');
}
