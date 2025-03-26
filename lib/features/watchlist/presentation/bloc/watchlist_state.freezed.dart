// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchListState1 {
  UiState<List<WatchListModel>> get watchListUiState;
  UiState<WatchListModel> get watchListDetailUiState;
  UiState get addFundToWatchListUiState;
  UiState get removeFundToWatchListUiState;

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WatchListState1CopyWith<WatchListState1> get copyWith =>
      _$WatchListState1CopyWithImpl<WatchListState1>(
          this as WatchListState1, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WatchListState1 &&
            (identical(other.watchListUiState, watchListUiState) ||
                other.watchListUiState == watchListUiState) &&
            (identical(other.watchListDetailUiState, watchListDetailUiState) ||
                other.watchListDetailUiState == watchListDetailUiState) &&
            (identical(other.addFundToWatchListUiState,
                    addFundToWatchListUiState) ||
                other.addFundToWatchListUiState == addFundToWatchListUiState) &&
            (identical(other.removeFundToWatchListUiState,
                    removeFundToWatchListUiState) ||
                other.removeFundToWatchListUiState ==
                    removeFundToWatchListUiState));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      watchListUiState,
      watchListDetailUiState,
      addFundToWatchListUiState,
      removeFundToWatchListUiState);

  @override
  String toString() {
    return 'WatchListState1(watchListUiState: $watchListUiState, watchListDetailUiState: $watchListDetailUiState, addFundToWatchListUiState: $addFundToWatchListUiState, removeFundToWatchListUiState: $removeFundToWatchListUiState)';
  }
}

/// @nodoc
abstract mixin class $WatchListState1CopyWith<$Res> {
  factory $WatchListState1CopyWith(
          WatchListState1 value, $Res Function(WatchListState1) _then) =
      _$WatchListState1CopyWithImpl;
  @useResult
  $Res call(
      {UiState<List<WatchListModel>> watchListUiState,
      UiState<WatchListModel> watchListDetailUiState,
      UiState<dynamic> addFundToWatchListUiState,
      UiState<dynamic> removeFundToWatchListUiState});

  $UiStateCopyWith<List<WatchListModel>, $Res> get watchListUiState;
  $UiStateCopyWith<WatchListModel, $Res> get watchListDetailUiState;
  $UiStateCopyWith<dynamic, $Res> get addFundToWatchListUiState;
  $UiStateCopyWith<dynamic, $Res> get removeFundToWatchListUiState;
}

/// @nodoc
class _$WatchListState1CopyWithImpl<$Res>
    implements $WatchListState1CopyWith<$Res> {
  _$WatchListState1CopyWithImpl(this._self, this._then);

  final WatchListState1 _self;
  final $Res Function(WatchListState1) _then;

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? watchListUiState = null,
    Object? watchListDetailUiState = null,
    Object? addFundToWatchListUiState = null,
    Object? removeFundToWatchListUiState = null,
  }) {
    return _then(_self.copyWith(
      watchListUiState: null == watchListUiState
          ? _self.watchListUiState
          : watchListUiState // ignore: cast_nullable_to_non_nullable
              as UiState<List<WatchListModel>>,
      watchListDetailUiState: null == watchListDetailUiState
          ? _self.watchListDetailUiState
          : watchListDetailUiState // ignore: cast_nullable_to_non_nullable
              as UiState<WatchListModel>,
      addFundToWatchListUiState: null == addFundToWatchListUiState
          ? _self.addFundToWatchListUiState!
          : addFundToWatchListUiState // ignore: cast_nullable_to_non_nullable
              as UiState<dynamic>,
      removeFundToWatchListUiState: null == removeFundToWatchListUiState
          ? _self.removeFundToWatchListUiState!
          : removeFundToWatchListUiState // ignore: cast_nullable_to_non_nullable
              as UiState<dynamic>,
    ));
  }

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UiStateCopyWith<List<WatchListModel>, $Res> get watchListUiState {
    return $UiStateCopyWith<List<WatchListModel>, $Res>(_self.watchListUiState,
        (value) {
      return _then(_self.copyWith(watchListUiState: value));
    });
  }

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UiStateCopyWith<WatchListModel, $Res> get watchListDetailUiState {
    return $UiStateCopyWith<WatchListModel, $Res>(_self.watchListDetailUiState,
        (value) {
      return _then(_self.copyWith(watchListDetailUiState: value));
    });
  }

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UiStateCopyWith<dynamic, $Res> get addFundToWatchListUiState {
    return $UiStateCopyWith<dynamic, $Res>(_self.addFundToWatchListUiState,
        (value) {
      return _then(_self.copyWith(addFundToWatchListUiState: value));
    });
  }

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UiStateCopyWith<dynamic, $Res> get removeFundToWatchListUiState {
    return $UiStateCopyWith<dynamic, $Res>(_self.removeFundToWatchListUiState,
        (value) {
      return _then(_self.copyWith(removeFundToWatchListUiState: value));
    });
  }
}

/// @nodoc

class _WatchListState1 implements WatchListState1 {
  _WatchListState1(
      {this.watchListUiState = const UiState.idle(),
      this.watchListDetailUiState = const UiState.idle(),
      this.addFundToWatchListUiState = const UiState.idle(),
      this.removeFundToWatchListUiState = const UiState.idle()});

  @override
  @JsonKey()
  final UiState<List<WatchListModel>> watchListUiState;
  @override
  @JsonKey()
  final UiState<WatchListModel> watchListDetailUiState;
  @override
  @JsonKey()
  final UiState<dynamic> addFundToWatchListUiState;
  @override
  @JsonKey()
  final UiState<dynamic> removeFundToWatchListUiState;

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WatchListState1CopyWith<_WatchListState1> get copyWith =>
      __$WatchListState1CopyWithImpl<_WatchListState1>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WatchListState1 &&
            (identical(other.watchListUiState, watchListUiState) ||
                other.watchListUiState == watchListUiState) &&
            (identical(other.watchListDetailUiState, watchListDetailUiState) ||
                other.watchListDetailUiState == watchListDetailUiState) &&
            (identical(other.addFundToWatchListUiState,
                    addFundToWatchListUiState) ||
                other.addFundToWatchListUiState == addFundToWatchListUiState) &&
            (identical(other.removeFundToWatchListUiState,
                    removeFundToWatchListUiState) ||
                other.removeFundToWatchListUiState ==
                    removeFundToWatchListUiState));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      watchListUiState,
      watchListDetailUiState,
      addFundToWatchListUiState,
      removeFundToWatchListUiState);

  @override
  String toString() {
    return 'WatchListState1(watchListUiState: $watchListUiState, watchListDetailUiState: $watchListDetailUiState, addFundToWatchListUiState: $addFundToWatchListUiState, removeFundToWatchListUiState: $removeFundToWatchListUiState)';
  }
}

/// @nodoc
abstract mixin class _$WatchListState1CopyWith<$Res>
    implements $WatchListState1CopyWith<$Res> {
  factory _$WatchListState1CopyWith(
          _WatchListState1 value, $Res Function(_WatchListState1) _then) =
      __$WatchListState1CopyWithImpl;
  @override
  @useResult
  $Res call(
      {UiState<List<WatchListModel>> watchListUiState,
      UiState<WatchListModel> watchListDetailUiState,
      UiState<dynamic> addFundToWatchListUiState,
      UiState<dynamic> removeFundToWatchListUiState});

  @override
  $UiStateCopyWith<List<WatchListModel>, $Res> get watchListUiState;
  @override
  $UiStateCopyWith<WatchListModel, $Res> get watchListDetailUiState;
  @override
  $UiStateCopyWith<dynamic, $Res> get addFundToWatchListUiState;
  @override
  $UiStateCopyWith<dynamic, $Res> get removeFundToWatchListUiState;
}

/// @nodoc
class __$WatchListState1CopyWithImpl<$Res>
    implements _$WatchListState1CopyWith<$Res> {
  __$WatchListState1CopyWithImpl(this._self, this._then);

  final _WatchListState1 _self;
  final $Res Function(_WatchListState1) _then;

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? watchListUiState = null,
    Object? watchListDetailUiState = null,
    Object? addFundToWatchListUiState = null,
    Object? removeFundToWatchListUiState = null,
  }) {
    return _then(_WatchListState1(
      watchListUiState: null == watchListUiState
          ? _self.watchListUiState
          : watchListUiState // ignore: cast_nullable_to_non_nullable
              as UiState<List<WatchListModel>>,
      watchListDetailUiState: null == watchListDetailUiState
          ? _self.watchListDetailUiState
          : watchListDetailUiState // ignore: cast_nullable_to_non_nullable
              as UiState<WatchListModel>,
      addFundToWatchListUiState: null == addFundToWatchListUiState
          ? _self.addFundToWatchListUiState
          : addFundToWatchListUiState // ignore: cast_nullable_to_non_nullable
              as UiState<dynamic>,
      removeFundToWatchListUiState: null == removeFundToWatchListUiState
          ? _self.removeFundToWatchListUiState
          : removeFundToWatchListUiState // ignore: cast_nullable_to_non_nullable
              as UiState<dynamic>,
    ));
  }

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UiStateCopyWith<List<WatchListModel>, $Res> get watchListUiState {
    return $UiStateCopyWith<List<WatchListModel>, $Res>(_self.watchListUiState,
        (value) {
      return _then(_self.copyWith(watchListUiState: value));
    });
  }

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UiStateCopyWith<WatchListModel, $Res> get watchListDetailUiState {
    return $UiStateCopyWith<WatchListModel, $Res>(_self.watchListDetailUiState,
        (value) {
      return _then(_self.copyWith(watchListDetailUiState: value));
    });
  }

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UiStateCopyWith<dynamic, $Res> get addFundToWatchListUiState {
    return $UiStateCopyWith<dynamic, $Res>(_self.addFundToWatchListUiState,
        (value) {
      return _then(_self.copyWith(addFundToWatchListUiState: value));
    });
  }

  /// Create a copy of WatchListState1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UiStateCopyWith<dynamic, $Res> get removeFundToWatchListUiState {
    return $UiStateCopyWith<dynamic, $Res>(_self.removeFundToWatchListUiState,
        (value) {
      return _then(_self.copyWith(removeFundToWatchListUiState: value));
    });
  }
}

// dart format on
