import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_app/core/utils/logger.dart';
import 'package:khazana_app/core/utils/ui_state.dart';
import 'package:khazana_app/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_event.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_state.dart';

// BLoC
class WatchListBloc extends Bloc<WatchListEvent, WatchListState1> {
  final WatchListRepository _watchListRepository;

  WatchListBloc(this._watchListRepository) : super(WatchListState1()) {
    on<WatchListLoadAllEvent>(_onLoadAll);
    on<WatchListLoadByIdEvent>(_onLoadById);
    on<WatchListCreateEvent>(_onCreate);
    // on<WatchListUpdateEvent>(_onUpdate);
    on<WatchListDeleteEvent>(_onDelete);
    on<WatchListAddFundEvent>(_onAddFund);
    on<WatchListRemoveFundEvent>(_onRemoveFund);
  }

  Future<void> _onLoadAll(
    WatchListLoadAllEvent event,
    Emitter<WatchListState1> emit,
  ) async {
    emit(state.copyWith(watchListUiState: UiState.loading()));
    try {
      final watchLists = await _watchListRepository.getAllWatchLists();
      await Future.delayed(const Duration(seconds: 3));
      if (watchLists.isNotEmpty) {
        emit(
          state.copyWith(watchListUiState: UiState.success(data: watchLists)),
        );
      } else {
        emit(state.copyWith(watchListUiState: UiState.empty()));
      }
    } catch (e) {
      logger.e(e);
      emit(
        state.copyWith(watchListUiState: UiState.failure(reason: e.toString())),
      );
      // emit(WatchListErrorState(e.toString()));
    }
  }

  Future<void> _onLoadById(
    WatchListLoadByIdEvent event,
    Emitter<WatchListState1> emit,
  ) async {
    emit(state.copyWith(watchListDetailUiState: UiState.loading()));
    try {
      final watchList = await _watchListRepository.getWatchListById(event.id);
      if (watchList != null) {
        emit(
          state.copyWith(
            watchListDetailUiState: UiState.success(data: watchList),
          ),
        );
      } else {
        emit(state.copyWith(watchListDetailUiState: UiState.empty()));
      }
    } catch (e) {
      logger.e(e);
      emit(
        state.copyWith(
          watchListDetailUiState: UiState.failure(reason: e.toString()),
        ),
      );
    }
  }

  Future<void> _onCreate(
    WatchListCreateEvent event,
    Emitter<WatchListState1> emit,
  ) async {
    emit(state.copyWith(watchListUiState: UiState.loading()));
    try {
      await _watchListRepository.createWatchList(event.name);
      add(
        WatchListLoadAllEvent(),
      ); // Reload all watchlists after creating a new one
    } catch (e) {
      logger.e(e);
      emit(
        state.copyWith(watchListUiState: UiState.failure(reason: e.toString())),
      );
    }
  }

  Future<void> _onUpdate(
    WatchListUpdateEvent event,
    Emitter<WatchListState> emit,
  ) async {
    emit(WatchListLoadingState());
    try {
      final watchList = await _watchListRepository.updateWatchList(
        event.watchList,
      );
      emit(WatchListDetailLoadedState(watchList));
      add(WatchListLoadAllEvent()); // Reload all watchlists after updating
    } catch (e) {
      logger.e(e);
      emit(WatchListErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    WatchListDeleteEvent event,
    Emitter<WatchListState1> emit,
  ) async {
    emit(state.copyWith(watchListUiState: UiState.loading()));
    try {
      await _watchListRepository.deleteWatchList(event.id);
      add(WatchListLoadAllEvent()); // Reload all watchlists after deleting
    } catch (e) {
      logger.e(e);
      emit(
        state.copyWith(watchListUiState: UiState.failure(reason: e.toString())),
      );
    }
  }

  Future<void> _onAddFund(
    WatchListAddFundEvent event,
    Emitter<WatchListState1> emit,
  ) async {
    emit(state.copyWith(addFundToWatchListUiState: UiState.loading()));
    try {
      final watchList = await _watchListRepository.addFundToWatchList(
        event.watchListId,
        event.fundId,
      );
      add(WatchListLoadByIdEvent(watchList.id));
      emit(state.copyWith(addFundToWatchListUiState: UiState.success()));
    } catch (e) {
      logger.e(e);
      emit(
        state.copyWith(
          addFundToWatchListUiState: UiState.failure(reason: e.toString()),
        ),
      );
    }
  }

  Future<void> _onRemoveFund(
    WatchListRemoveFundEvent event,
    Emitter<WatchListState1> emit,
  ) async {
    emit(state.copyWith(removeFundToWatchListUiState: UiState.loading()));
    try {
      final watchList = await _watchListRepository.removeFundFromWatchList(
        event.watchListId,
        event.fundId,
      );
      add(WatchListLoadByIdEvent(watchList.id));
      emit(state.copyWith(removeFundToWatchListUiState: UiState.success()));
    } catch (e) {
      logger.e(e);
      emit(
        state.copyWith(
          removeFundToWatchListUiState: UiState.failure(reason: e.toString()),
        ),
      );
    }
  }
}
