import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/domain/repositories/watchlist_repository.dart';

// WatchList Events
abstract class WatchListEvent extends Equatable {
  const WatchListEvent();

  @override
  List<Object?> get props => [];
}

class WatchListLoadAllEvent extends WatchListEvent {}

class WatchListLoadByIdEvent extends WatchListEvent {
  final String id;

  const WatchListLoadByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}
//  ////////////////////////////////

class WatchListCreateEvent extends WatchListEvent {
  final String name;

  const WatchListCreateEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class WatchListUpdateEvent extends WatchListEvent {
  final WatchListModel watchList;

  const WatchListUpdateEvent(this.watchList);

  @override
  List<Object?> get props => [watchList];
}

class WatchListDeleteEvent extends WatchListEvent {
  final String id;

  const WatchListDeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class WatchListAddFundEvent extends WatchListEvent {
  final String watchListId;
  final String fundId;

  const WatchListAddFundEvent(this.watchListId, this.fundId);

  @override
  List<Object?> get props => [watchListId, fundId];
}

class WatchListRemoveFundEvent extends WatchListEvent {
  final String watchListId;
  final String fundId;

  const WatchListRemoveFundEvent(this.watchListId, this.fundId);

  @override
  List<Object?> get props => [watchListId, fundId];
}

// States
abstract class WatchListState extends Equatable {
  const WatchListState();

  @override
  List<Object?> get props => [];
}

class WatchListInitialState extends WatchListState {}

class WatchListLoadingState extends WatchListState {}

class WatchListLoadedState extends WatchListState {
  final List<WatchListModel> watchLists;

  const WatchListLoadedState(this.watchLists);

  @override
  List<Object?> get props => [watchLists];
}

class WatchListDetailLoadedState extends WatchListState {
  final WatchListModel watchList;

  const WatchListDetailLoadedState(this.watchList);

  @override
  List<Object?> get props => [watchList];
}

class WatchListErrorState extends WatchListState {
  final String message;

  const WatchListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class WatchListBloc extends Bloc<WatchListEvent, WatchListState> {
  final WatchListRepository _watchListRepository;

  WatchListBloc(this._watchListRepository) : super(WatchListInitialState()) {
    on<WatchListLoadAllEvent>(_onLoadAll);
    on<WatchListLoadByIdEvent>(_onLoadById);
    on<WatchListCreateEvent>(_onCreate);
    on<WatchListUpdateEvent>(_onUpdate);
    on<WatchListDeleteEvent>(_onDelete);
    on<WatchListAddFundEvent>(_onAddFund);
    on<WatchListRemoveFundEvent>(_onRemoveFund);
  }

  Future<void> _onLoadAll(
    WatchListLoadAllEvent event,
    Emitter<WatchListState> emit,
  ) async {
    emit(WatchListLoadingState());
    try {
      final watchLists = await _watchListRepository.getAllWatchLists();
      emit(WatchListLoadedState(watchLists));
    } catch (e) {
      emit(WatchListErrorState(e.toString()));
    }
  }

  Future<void> _onLoadById(
    WatchListLoadByIdEvent event,
    Emitter<WatchListState> emit,
  ) async {
    emit(WatchListLoadingState());
    try {
      final watchList = await _watchListRepository.getWatchListById(event.id);
      if (watchList != null) {
        add(WatchListLoadAllEvent());
        emit(WatchListDetailLoadedState(watchList));
      } else {
        emit(const WatchListErrorState('WatchList not found'));
      }
    } catch (e) {
      emit(WatchListErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(
    WatchListCreateEvent event,
    Emitter<WatchListState> emit,
  ) async {
    emit(WatchListLoadingState());
    try {
      final watchList = await _watchListRepository.createWatchList(event.name);
      emit(WatchListDetailLoadedState(watchList));
      add(
        WatchListLoadAllEvent(),
      ); // Reload all watchlists after creating a new one
    } catch (e) {
      emit(WatchListErrorState(e.toString()));
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
      emit(WatchListErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    WatchListDeleteEvent event,
    Emitter<WatchListState> emit,
  ) async {
    emit(WatchListLoadingState());
    try {
      await _watchListRepository.deleteWatchList(event.id);
      add(WatchListLoadAllEvent()); // Reload all watchlists after deleting
    } catch (e) {
      emit(WatchListErrorState(e.toString()));
    }
  }

  Future<void> _onAddFund(
    WatchListAddFundEvent event,
    Emitter<WatchListState> emit,
  ) async {
    emit(WatchListLoadingState());
    try {
      final watchList = await _watchListRepository.addFundToWatchList(
        event.watchListId,
        event.fundId,
      );
      emit(WatchListDetailLoadedState(watchList));
    } catch (e) {
      emit(WatchListErrorState(e.toString()));
    }
  }

  Future<void> _onRemoveFund(
    WatchListRemoveFundEvent event,
    Emitter<WatchListState> emit,
  ) async {
    emit(WatchListLoadingState());
    try {
      final watchList = await _watchListRepository.removeFundFromWatchList(
        event.watchListId,
        event.fundId,
      );
      emit(WatchListDetailLoadedState(watchList));
    } catch (e) {
      emit(WatchListErrorState(e.toString()));
    }
  }
}
