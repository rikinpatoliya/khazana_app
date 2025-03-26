// WatchListState
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:khazana_app/core/utils/ui_state.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
part 'watchlist_state.freezed.dart';

@freezed
abstract class WatchListState1 with _$WatchListState1 {
  factory WatchListState1({
    @Default(UiState.idle()) UiState<List<WatchListModel>> watchListUiState,
    @Default(UiState.idle()) UiState<WatchListModel> watchListDetailUiState,
    @Default(UiState.idle()) UiState addFundToWatchListUiState,
    @Default(UiState.idle()) UiState removeFundToWatchListUiState,
  }) = _WatchListState1;
}
