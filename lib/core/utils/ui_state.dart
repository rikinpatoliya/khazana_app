import 'package:freezed_annotation/freezed_annotation.dart';

part 'ui_state.freezed.dart';

/* enum UiStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == UiStatus.initial;
  bool get isLoading => this == UiStatus.loading;
  bool get isSuccess => this == UiStatus.success;
  bool get isFailure => this == UiStatus.failure;
} */

@freezed
abstract class UiState<T> with _$UiState<T> {
  const UiState._();
  const factory UiState.idle() = Idle<T>;

  const factory UiState.loading() = Loading<T>;

  const factory UiState.success({T? data}) = Success<T>;

  const factory UiState.empty() = Empty<T>;

  const factory UiState.failure({String? reason}) = Failure<T>;
}
