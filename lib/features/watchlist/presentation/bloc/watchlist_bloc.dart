import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/domain/repositories/watchlist_repository.dart';

// Events
abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class WatchlistLoadAllEvent extends WatchlistEvent {}

class WatchlistLoadByIdEvent extends WatchlistEvent {
  final String id;

  const WatchlistLoadByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class WatchlistCreateEvent extends WatchlistEvent {
  final String name;

  const WatchlistCreateEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class WatchlistUpdateEvent extends WatchlistEvent {
  final WatchlistModel watchlist;

  const WatchlistUpdateEvent(this.watchlist);

  @override
  List<Object?> get props => [watchlist];
}

class WatchlistDeleteEvent extends WatchlistEvent {
  final String id;

  const WatchlistDeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class WatchlistAddFundEvent extends WatchlistEvent {
  final String watchlistId;
  final String fundId;

  const WatchlistAddFundEvent(this.watchlistId, this.fundId);

  @override
  List<Object?> get props => [watchlistId, fundId];
}

class WatchlistRemoveFundEvent extends WatchlistEvent {
  final String watchlistId;
  final String fundId;

  const WatchlistRemoveFundEvent(this.watchlistId, this.fundId);

  @override
  List<Object?> get props => [watchlistId, fundId];
}

// States
abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitialState extends WatchlistState {}

class WatchlistLoadingState extends WatchlistState {}

class WatchlistLoadedState extends WatchlistState {
  final List<WatchlistModel> watchlists;

  const WatchlistLoadedState(this.watchlists);

  @override
  List<Object?> get props => [watchlists];
}

class WatchlistDetailLoadedState extends WatchlistState {
  final WatchlistModel watchlist;

  const WatchlistDetailLoadedState(this.watchlist);

  @override
  List<Object?> get props => [watchlist];
}

class WatchlistErrorState extends WatchlistState {
  final String message;

  const WatchlistErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository _watchlistRepository;

  WatchlistBloc(this._watchlistRepository) : super(WatchlistInitialState()) {
    on<WatchlistLoadAllEvent>(_onLoadAll);
    on<WatchlistLoadByIdEvent>(_onLoadById);
    on<WatchlistCreateEvent>(_onCreate);
    on<WatchlistUpdateEvent>(_onUpdate);
    on<WatchlistDeleteEvent>(_onDelete);
    on<WatchlistAddFundEvent>(_onAddFund);
    on<WatchlistRemoveFundEvent>(_onRemoveFund);
  }

  Future<void> _onLoadAll(
    WatchlistLoadAllEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoadingState());
    try {
      final watchlists = await _watchlistRepository.getAllWatchlists();
      emit(WatchlistLoadedState(watchlists));
    } catch (e) {
      emit(WatchlistErrorState(e.toString()));
    }
  }

  Future<void> _onLoadById(
    WatchlistLoadByIdEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoadingState());
    try {
      final watchlist = await _watchlistRepository.getWatchlistById(event.id);
      if (watchlist != null) {
        emit(WatchlistDetailLoadedState(watchlist));
      } else {
        emit(const WatchlistErrorState('Watchlist not found'));
      }
    } catch (e) {
      emit(WatchlistErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(
    WatchlistCreateEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoadingState());
    try {
      final watchlist = await _watchlistRepository.createWatchlist(event.name);
      emit(WatchlistDetailLoadedState(watchlist));
      add(
        WatchlistLoadAllEvent(),
      ); // Reload all watchlists after creating a new one
    } catch (e) {
      emit(WatchlistErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(
    WatchlistUpdateEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoadingState());
    try {
      final watchlist = await _watchlistRepository.updateWatchlist(
        event.watchlist,
      );
      emit(WatchlistDetailLoadedState(watchlist));
      add(WatchlistLoadAllEvent()); // Reload all watchlists after updating
    } catch (e) {
      emit(WatchlistErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    WatchlistDeleteEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoadingState());
    try {
      await _watchlistRepository.deleteWatchlist(event.id);
      add(WatchlistLoadAllEvent()); // Reload all watchlists after deleting
    } catch (e) {
      emit(WatchlistErrorState(e.toString()));
    }
  }

  Future<void> _onAddFund(
    WatchlistAddFundEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoadingState());
    try {
      final watchlist = await _watchlistRepository.addFundToWatchlist(
        event.watchlistId,
        event.fundId,
      );
      emit(WatchlistDetailLoadedState(watchlist));
    } catch (e) {
      emit(WatchlistErrorState(e.toString()));
    }
  }

  Future<void> _onRemoveFund(
    WatchlistRemoveFundEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoadingState());
    try {
      final watchlist = await _watchlistRepository.removeFundFromWatchlist(
        event.watchlistId,
        event.fundId,
      );
      emit(WatchlistDetailLoadedState(watchlist));
    } catch (e) {
      emit(WatchlistErrorState(e.toString()));
    }
  }
}
