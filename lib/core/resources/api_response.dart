sealed class ApiResponse<T> {
  const ApiResponse._();
  factory ApiResponse.success(T value) = ApiResponseSuccess<T>._;
  factory ApiResponse.error(String message) = ApiResponseError._;
}

class ApiResponseSuccess<T> extends ApiResponse<T> {
  const ApiResponseSuccess._(this.value) : super._();

  final T value;
}

class ApiResponseError extends ApiResponse<Never> {
  const ApiResponseError._(this.message) : super._();

  final String message;
}
